/*
   Last Modified Time: April 24, 2026 at 6:23:03 AM
*/

/*    
      This is a data logger which collects the transmissions from a  David Integrated
      sensor suite and was based on a DeKay demo.  It utilises a slightly modified version of
      DeKay's DavisRFM69 library.

      Firmware version declared in Defs.h

      ---> THIS IS INTENDED FOR USE WITH AN ESP32 <---
      Version info 
      1.15.3  29/05/2025  Code surrounding the collection of WorldTime and NTP
                          time settings due to the slow response from the current
                          WorldTime server.
      1.15.4  12/06/2025  Original NTP and WT time collectors replaced by lwip sntp
                          routines sntp_init and sntp_get_system_time.
                          WorldTime abandoned completely.
      1.15.5  27/11/2025  First version using PlatformIO
                          SSID's reduced to one stored in SsidList.Entry[0]
                          Timezone info stored in SsidList.Entry[1]
                          Menu options rationalised
      1.20.1  01/03/2026  SD moved to HSPI
                          RFM kept on VSPI but returned to interupt driven
                          Client comms returned to UDP
                          All HSPI/SD and UDP comms placed on core 0
*/
//#include <Arduio.h>
//#include <DavisServer.h>
//#include <SPI.h>
#include <WiFi.h>
#include <AsyncUDP.h>
#include <time.h>     // time() ctime()
#include <sys/time.h> // struct timeval
#include <esp_sntp.h>
#include <SdFat.h> 
//#include <Ticker.h>
#include <math.h>
//#include <AT_gen_Utils.h>
#include <time.h>
#include <CRC32.h>
#include <CRC.h>
#include "DavisRFM69.h"
#include <Adafruit_BMP280.h>
#include "ISSFlash.h"
#include "Menu.h"
#include "Defs.h" 
#include "DavisISSLib.h"
#include "CommonDefs.h"
#include "SDFunctions.h"
#include "Logger.h"
#include "flashLED.h"

//#define ESP32
#define DAVIS_FREQS_EU


// NOTE: *** One of DAVIS_FREQS_US, DAVIS_FREQS_EU, DAVIS_FREQS_AU, or  
// DAVIS_FREQS_NZ MUST be defined at the top of DavisRFM69.h ***

/*  ESP32 Module - GPIO pins used for SPI and I2C busses
 *  Physical module pins vary according to the module chosen
 *
 *  ---------------------------------------------------------
 *  VSPI PINS RFM69 Control
 *  GPIO18  SCLK
 *  GPIO19  MSIO
 *  GPIO23  MOSI
 *  GPIO5   Default CS (NOT USED) 
 *
 *  CHIP Select, Interrup and RESET pins 
 *  GPIO4   RFM69 CS
 *  GPIO16  RFM69 INT   - Int input from RFM69
 *  GPIO17  RFM69 RESET - O/P
 *  ---------------------------------------------------------
 *  HSPI PINS - Default pins 27 & 13 DO NOT WORK!
 *  SD_SCK  14
 *  SD_MISO 27 // default is 12 which is a strapping pin
 *  SD_MOSI 13
 *  SD_CS   26 // default is 15 which is a strapping pin
 *  ---------------------------------------------------------
 *  BMP280 BAROMETRIC PRESSURE
 *  I2C SCL   - GPIO22
 *  I2C SDA   - GPIO21
 *  --------------------------------------------------------- 
 */

 struct taskShare {
  uint16_t myint;
  bool    ready;
};

#define SD_CONFIG SdSpiConfig(HSD_CS, SHARED_SPI, SD_SCK_MHZ(10), &hspi)

DavisRFM69  radio;
AsyncUDP    udp;
Adafruit_BMP280 bmp; // use I2C interface
SdFs        sd;
SDcmd       sdc;
taskShare   share;
TaskHandle_t Task2;
taskShare* ts;

TFlashData  SysData;
TSSIDLIST   SsidList;
hw_timer_t  *OneSecond_timer = NULL;
char        __printbuf[PRINTBUFSIZE];
RemoteRequest reqInfo;
RemoteRequest remoteRequest;
LiveData    liveData;
DiskInfo    diskInfo;
CmdQueue    cQueue;

//flashLED    bluLED;
flashLED    grnLED;
flashLED    redLED;

// Create a new SPI instance
SPIClass hspi(HSPI);
SPIClass vspi(VSPI);

// This data is persistent through a reboot
WsData wsData __attribute__ ((section (".noinit")));

const char * OnOff[2] = {"Off", "On"};

volatile  DateInfo    dateInfo;
          uint32_t    RXFlashCount = 0;
          uint32_t    SDFlashCount = 0;
          uint32_t    GRNFlashCount = 0;
          long        lastPeriod = -1;
          uint16_t    loopCount = 0;
          uint8_t     writecount = 0;
          uint8_t     lastChannel;
          bool        rxIsOn = true;
volatile  bool        SaveDataFlag = false;
          char        LogFile[25];
          uint8_t     __retryCount = 5;
          bool        BMPpresent = false;
          RFMPacketStats packetStats;
          uint32_t    crcErrors[DAVIS_FREQ_TABLE_LENGTH];
          uint32_t    lostErrors[DAVIS_FREQ_TABLE_LENGTH];
          int32_t     runningRSSI = -60;
          

void processPacket();
void DumpRadioData(char * s);
void IRAM_ATTR onTimer();
void IRAM_ATTR RFM_Interrupt();
void SetData() ;


void ConfigSD();
void AppendLog(const char* message);
void AppendData(const char* message, const char* filename);
RemoteRequest DecodeJsonRequest(const char * jstext);
void Task2code(void * pvParameters );
void SaveWsData();

/*****************************************************************/

void setup() {

  delay(1000);
  ClearLog();

/*** IO Setup ***/

grnLED.setIO(32);
redLED.setIO(2);
  
/* On some ESP32 board variants the wifi
 * will not connect without this */
  ESP32_enable_wifi();

// set up a 100ms timer, start it early as the ticks are needed for the leds.
    OneSecond_timer = timerBegin(0, 80, true);              // timer number (0), prescaler (80) 1MHz, count up
    timerAttachInterrupt(OneSecond_timer, &onTimer, true);  // attach the interrupt
    timerAlarmWrite(OneSecond_timer, 100000, true);        // div prescaled clock (1MHz) by 100000 so 100mS, enabled
    timerAlarmEnable(OneSecond_timer);                      // start timer

// show booting

  Serial.begin(SERIAL_BAUD);
  Serial.println("");
  timePrint("***************", dateInfo.CurDate, dateInfo.CurTime);
  timePrint("Setup()", dateInfo.CurDate, dateInfo.CurTime);
  sprintf(__printbuf, "RESTART REASON: %s", GetBootReason(esp_reset_reason()));// boot_reasons[esp_reset_reason()]);
  timePrint(__printbuf, dateInfo.CurDate, dateInfo.CurTime);

  char freq_table[16];
  
  #ifdef DAVIS_FREQS_AU
    strcpy(freq_table, "DAVIS_FREQS_AU");
  #endif
  #ifdef DAVIS_FREQS_EU
    strcpy(freq_table, "DAVIS_FREQS_EU");
  #endif
  #ifdef DAVIS_FREQS_NZ
    strcpy(freq_table, "DAVIS_FREQS_NZ");
  #endif

  timePrint(freq_table, dateInfo.CurDate, dateInfo.CurTime);

/* --------------------------------------------------  
    RFM chip configuration 
*/
// set the int pin and reset the chip 
  pinMode(RFM_INT,    INPUT_PULLDOWN);  // RFM DATA READY INT
  pinMode(RFM_RESET,  OUTPUT);          // RFM RESET

// Reset the RFM see 7.2.2 in the manual
  digitalWrite(RFM_RESET, HIGH);
  delay(100);
  digitalWrite(RFM_RESET, LOW);
  delay(5);

// init the RFM's spi
  vspi.begin(VSD_SCK, VSD_MISO, VSD_MOSI, VSD_CS);
  
// <--- Init RFM with INTERRUPT <<
  if (!radio.initialize(0, &vspi)) {
    radio.setChannel(0);         // Initial radio channel
    timePrint("RFM95 Module initialised", dateInfo.CurDate, dateInfo.CurTime);
  } else {
    timePrint("--> RFM95 Module did not respond", dateInfo.CurDate, dateInfo.CurTime);
  }
  // Attach interrupt: pin, function, mode
  attachInterrupt(digitalPinToInterrupt(RFM_INT), RFM_Interrupt, RISING);
  radio.setChannel(0);

  packetStats.crcErrors = 0;
  packetStats.failCount = 0;
  packetStats.packetperiod = 0;
  packetStats.syncLost = true;
 
// ---------------------------------------------------

//  Setup HSPI (SD)
  hspi.begin(HSD_SCK, HSD_MISO, HSD_MOSI, HSD_CS); // SD

/*  
    * Init the pressure sensor (BMP280)
    * Provides power for the BMP280, allowing it to be reset
    * at powerup and after a reboot. 
    * See manual table 2 for parameter values.
    * Max supply current 1.12mA.
*/      
  pinMode(BMP_ENABLE, OUTPUT);    // BMP POWER
  digitalWrite(BMP_ENABLE, LOW);  // BMP POWER OFF
  delay(100);
  digitalWrite(BMP_ENABLE, HIGH);  // BMP POWER ON 
  delay(500);

  BMPpresent = bmp.begin(0x77); // use default address, 0x77

  if (BMPpresent) {
    // Default settings from datasheet.
    bmp.setSampling(Adafruit_BMP280::MODE_NORMAL,     //* Operating Mode.
                    Adafruit_BMP280::SAMPLING_X2,     //* Temp. oversampling
                    Adafruit_BMP280::SAMPLING_X16,    //* Pressure oversampling
                    Adafruit_BMP280::FILTER_X16,      //* Filtering
                    Adafruit_BMP280::STANDBY_MS_500); //* Standby time

    // initial pressure reading
    wsData.Pressure = (static_cast<uint32_t>(bmp.readPressure())) / 10;
    sprintf(__printbuf, "Initial barometric pressure: %d", wsData.Pressure);
    timePrint(__printbuf, dateInfo.CurDate, dateInfo.CurTime);
  } else {
    timePrint("--> BMP sensor not present", dateInfo.CurDate, dateInfo.CurTime);
  }

  ReadFlashData(&SysData, &SsidList);
  timePrint("Flash read", dateInfo.CurDate, dateInfo.CurTime);

  //  check weather station data that is retained over a restart  
  if (CheckData(&wsData)) {
    timePrint("CRC Passed - wsData OK", dateInfo.CurDate, dateInfo.CurTime);
  } else {
    fillData(&wsData);
    timePrint("--> CRC failed - wsData initialised", dateInfo.CurDate, dateInfo.CurTime);
  }

// Connect wifi
  if (activateWiFi2(SsidList, 10, SsidList, SysData.hostName)) {
  //  Start the NTP system
    Init_ESP_SNTP(NTP_SERVER, SysData.UTC_Offset, SysData.DST_Offset, SysData.UseDST);
    timePrint("ESP NTP initialised", dateInfo.CurDate, dateInfo.CurTime);

    tm nt;
    ntpTime tntp;
    uint8_t ntpcount = 40; // 10 seconds in 250ms chunks

    Serial.print(" Waiting for time synchronisation ");
    grnLED.flash(2);
/*  * Wait for NTP to become correct, 10S allowed.
    * Initial readings start from zero so an easy
    * check for validity */
    do {
      tntp = Get_ESP_NTP_Time(&nt);
      Serial.print(".");
      ntpcount--;
      delay(250);
    } while ((tntp.Sv < 1000000) && (ntpcount > 0));
    
    if((tntp.Sv > 1000000) and (ntpcount > 0)) {
      Serial.println(" synchronised");
      dateInfo.useDST = SysData.UseDST;
      dateInfo.BootTime = nt.tm_wday;   // dateInfo.CurTime;
      dateInfo.CurTime  = nt.tm_wday;
      dateInfo.BootDate = nt.tm_yday;   //dateInfo.CurDate;
      dateInfo.CurDate  = nt.tm_yday;
      char buf1[30];
      char buf2[50];
      DateTimeToString(buf1, nt.tm_yday, nt.tm_wday, nt.tm_isdst);
      sprintf(buf2, "Time synchronised %s", buf1);
      timePrint(buf2, dateInfo.CurDate, dateInfo.CurTime);
    } else
      timePrint((char *) "Time failed to synchronise", dateInfo.CurDate, dateInfo.CurTime);

    grnLED.off();

    // create logfile name after the time is set
    ConfigSD();
    makeLogFilename(LogFile, dateInfo.CurDate);
    sprintf(__printbuf, "Data filename: %s", LogFile);
    timePrint(__printbuf, dateInfo.CurDate, dateInfo.CurTime);

    dateInfo.SecondsElapsed = dateInfo.CurTime % 60;
 
    dateInfo.lastSave = dateInfo.CurTime;

    timePrint("End of setup()", dateInfo.CurDate, dateInfo.CurTime);

    Serial.println("\r\nPress M <cr> to show menu\r\n");
    
    udp.listen(_APORT);

//  Flush the UDP command queue
    cQueue.flush();
  
//  Init and run core 0
    xTaskCreatePinnedToCore(
                      Task2code,   /* Task function. */
                      "CORE_0",    /* name of task. */
                      10000,       /* Stack size of task */
                      &share,      /* parameter of the task */
                      1,           /* priority of the task */
                      &Task2,      /* Task handle to keep track of created task */
                      0);          /* pin task to core 0 */

/*    
    ***************************************** 
    ***** UDP incomming packet handler ******
    ***************************************** 
 */
    udp.onPacket( [](AsyncUDPPacket packet) {

        char buf[100];
        uint8_t len = packet.length();
        uint8_t * inidx = packet.data();
        uint8_t outidx = 0;
        RemoteRequest rq;

//      copy the packet data into the buffer
//      until the closing } is found
        do {
          buf[outidx++] = *(inidx++);
          buf[outidx] = 0;

        } while ((*(inidx - 1) != '}') && (outidx < len))
            ;

        rq = DecodeJsonRequest(buf);
        Serial.printf("UDP REQ <%s> <%d> <%s> <%s> <%d>\n", rq.Data, rq.date, rq.FileName, rq.IP.toString(), rq.Request);
        cQueue.push(rq);
      } 
    );
  }
  
}

/*****************************************************************/

void loop() {

  if (SaveDataFlag) { // the save data flag is set by the 1S ISR

    SaveWsData();
    dateInfo.lastSave = dateInfo.CurTime;
    SaveDataFlag = false;

    if (dateInfo.CurTime % 60 == 0) 
      AppendLogBuffer(); // request log to be flushed to SD      
  }

//  async functions called once per second
  if (dateInfo.secondFlag) { // flag set by ISR
    MinuteCheck(LogFile, &dateInfo, &wsData, packetStats); // check necessary timed actions
    dateInfo.secondFlag = false;
  }

  serialEvent();  

//  check for low signal and flag if necessary
  if(packetStats.packetReady) {
    processPacket();
    Serial.printf("Packets: %5d <%s>\n", 
                            packetStats.packetsReceived, 
                            __printbuf);
    packetStats.packetReady = false;
    __printbuf[0] = 0;
    runningRSSI =  (runningRSSI + WiFi.RSSI()) / 2;
  }

}

/* ******************************************
 * RFM69 Data ready interrupt
 * ******************************************/
void IRAM_ATTR RFM_Interrupt() {
  
  packetStats.packetReady = false;

  if((packetStats.syncLost == false) && (packetStats.packetperiod < 21)) {
  // this is an error situation so abort the interrupt
    return;
  }
  
//  packetStats.tag = 0;
  packetStats.packetsReceived++;
  packetStats.packetperiod = 0;
        
//  packetStats.lastRxTime = 0;
  packetStats.syncLost = false;
  packetStats.failCount = 0;

  grnLED.pulse(2); // pulse for 200ms to indicate a packet
  radio.CollectData(); // collect WS data and place in buffer
  radio.hop();
      
//  System info data. Do this even if the CRC is invalid
  wsData.Other.BatteryStatus = !(radio.DATA[0] & 0x8) == 0x8; // battery state
  wsData.RSSI += radio.RSSI;
  wsData.RSSI /= 2;  // keep an average of the RSSI

  uint16_t crc = radio.crc16_ccitt(radio.DATA, 6);
  if ((crc == (word(radio.DATA[6], radio.DATA[7]))) && (crc != 0))  {
    processPacket();
    packetStats.receivedStreak++;      
    packetStats.packetReady = true;
    SetData();
  } else {
    packetStats.crcErrors++;
    packetStats.receivedStreak = 0;      
  }
}

void SaveWsData() {

  if (BMPpresent) 
    wsData.Pressure = (static_cast<uint32_t>(bmp.readPressure())) / 10;
      
  wsData.Other.dataCRC = calcCRC32((uint8_t *) &wsData, WSDATA_CRC_BYTE_COUNT);

  sprintf(wsData.Other.sdBuffer, "%05X %03X %02X %03X %04X %03X %04X %03X %02X %04X %02X",
            dateInfo.CurTime,
            wsData.AvWindDir,       // Degrees
            wsData.AvWindSpeed,     // MPH
            wsData.PkWindSpeed,     // MPH
            wsData.Temperature,     // deg F * 10
            wsData.Humidity,        // % RH * 10
            wsData.TotalDayRain,    // tips
            wsData.TotalHourRain,   // tips
            wsData.TotalMinRain,    // tips
            wsData.Pressure,        // HPa * 10
            wsData.RSSI & 0xFF);    // running RSSI measurement

    // flag that data is ready to save, picked up in loop()
    SaveDataFlag = false;

    AppendData(wsData.Other.sdBuffer, LogFile);
    Serial.println("--> Saved <--");
}

/* ******************************************
 * One second Timer interrupt
 * The timer runs at 100mS and is further
 * divided by 10 for the time counter.
 * Handles: Time incrementing
 *          Constructs the time flags
 *          Assembles data for saving
 * ******************************************/

 uint8_t timecount;

void IRAM_ATTR onTimer() {
// 100ms ticks

//  trigger the LED actions for the flashLED objects.  
//  These are used to flash the LEDs in the main loop without blocking the code.  

// LED flashing
  redLED.tick();
  grnLED.tick();

  timecount++;

// -- Check for missing packets
  if (!packetStats.syncLost) 
      packetStats.packetperiod++;

  if (packetStats.packetperiod > 27) {
//  missed packet!
    packetStats.packetperiod = 0;
    packetStats.failCount++;
    packetStats.packetsMissed++;
    packetStats.receivedStreak = 0;

//  force the channel to stay on zero once sync is lost
    if (packetStats.failCount == FAIL_THRESHOLD) {
      radio.setChannel(0);
      packetStats.syncLost = true;
    }

//  hop if not wating for a resync
    if (!packetStats.syncLost) {
      radio.hop();
    }
  }  
 
  if (timecount == 10) {
  
// ------- 1 second ticks --------

    timecount = 0;

    dateInfo.TimeFlags = getTimeStatus(&dateInfo);
    dateInfo.secondFlag = true;

  /* Increment the time ony if DAYCHANGE is not set.  If
  it is set then the time has just been reset to zero */
    if ((dateInfo.TimeFlags & DAYCHANGE) == 0) 
      dateInfo.CurTime++; 
    
    dateInfo.SecondsElapsed++;

    if (dateInfo.SecondsElapsed > 59) {
      SaveDataFlag = true;
      dateInfo.SecondsElapsed = 0;
    }
  }
}

/* ******************************************/

/*
 * Read the data from the ISS packet 
 * Temperature:         0.1F
 * Humidity:            0.1%
 * Live wind:           averaged
 * Saved wind:          averaged at the end of each minute
 * Barometric pressure: not done here as the ISS doesnt measure this
 * CRC:                 calculated at the end.
 * RSSI and battery:    collected elsewhere
 */
void processPacket() {

  if ((radio.DATA[0] & 0x0F) == 0) { // is it an ISS (zero)

    liveData.Pressure = wsData.Pressure;
    liveData.RSSI = radio.RSSI;

//  wind direction live data
    liveData.WindDir = round(radio.DATA[2] * WIND_DIR_CORRECTION);
    if (liveData.WindDir < 0)
      liveData.WindDir += 360;

    //  collect peak wind speed
    liveData.WindSpeed = radio.DATA[1];
    if (wsData.PkWindSpeed < radio.DATA[1])
      wsData.PkWindSpeed = radio.DATA[1];

    //  2.56 second DATA
    // Wind speed
    if (wsData.Index < 24)
    {
      wsData.WindSpd[wsData.Index] = radio.DATA[1]; // Wind speed
      wsData.WindDir[wsData.Index] = radio.DATA[2]; // Wind direction
    }

    wsData.Index++;

    //  Collect the battery and RSSi info in the interrupt

    //  10.24 second DATA
    switch (radio.DATA[0] >> 4) {
      case TEMPDATA:
        wsData.Temperature = round(((uint16_t)radio.DATA[3] << 8 | radio.DATA[4]) / 16.0); // 1/10 degree resolution
        liveData.Temperature = wsData.Temperature; 
        break;
      case HUMIDATA:
        wsData.Humidity = round((float)(word((radio.DATA[4] >> 4), radio.DATA[3]))); // 1/10 percent resolution
        liveData.Humidity = wsData.Humidity;
        break;
      case RAINDATA:                  // the tip count has a max value of 0x7F
        if (wsData.Other.LastTip == 0xFF) { // init tips on the first pass
          wsData.Other.LastTip  = radio.DATA[3];
          wsData.TotalDayRain   = 0;
          wsData.TotalHourRain  = 0;
          wsData.TotalMinRain   = 0;
        }

        uint16_t newTips = 0;

        if (wsData.Other.LastTip != radio.DATA[3]) { // every 2.5s
        // allow for tip count rollover
          if (wsData.Other.LastTip > radio.DATA[3])
            newTips = (radio.DATA[3] | 0x80) - wsData.Other.LastTip;
          else
            newTips = radio.DATA[3] - wsData.Other.LastTip;

          wsData.Other.LastTip   = radio.DATA[3];
          wsData.TotalDayRain   += newTips;
          wsData.TotalHourRain  += newTips;
          wsData.TotalMinRain   += newTips;
        }
        liveData.HourlyRain = wsData.TotalHourRain;
        break;
    }

    // Average the wind direction and speed data every 24 samples (61.44s).  This is async with the sd save
    // routine so just process the data, place it in the buffer and leave it to be saved later.
    if (wsData.Index > 23) {
      wsData.AvWindSpeed = AverageWindSpeed(wsData.WindSpd); // average the wind speed
      wsData.AvWindDir = meanAngle(wsData.WindDir, 24);      // average the wind direction

      //  make wind direction a positive value only (0 to 359 degrees)
      if (wsData.AvWindDir < 0)
        wsData.AvWindDir += 360;

      wsData.Index = 0;
    }
//  update crc  
    wsData.Other.dataCRC = calcCRC32((uint8_t *) &wsData, WSDATA_CRC_BYTE_COUNT);
  }
}

void GetLastData(char buf[50])
{

  char *p = wsData.Other.sdBuffer;
  byte i = 0;
  buf[0] = 0;

  while (*p != 0)
  {
    if (*p == ' ')
      buf[i++] = '_';
    else
      buf[i++] = *p;

    p++;
    *p = 0;
  }
}

void ConfigSD() {

  if (!sd.begin(SD_CONFIG))  {
    sdc.active = false;
    diskInfo.sdActive = false;
  } else {
    sdc.active = true;
    diskInfo.sdActive = true;
  }      
  
  if (!diskInfo.sdActive) {
    sprintf(__printbuf, "--> SD interface/card failed, or not present");
    timePrint(__printbuf, dateInfo.CurDate, dateInfo.CurTime);
  } else {
//  SD logging directory
    if (!sd.exists("/Data")) {
      if (sd.mkdir("/Data")) {
        timePrint("/Data folder created", dateInfo.CurDate, dateInfo.CurTime);
      }
    }
    
    timePrint("SD interface and card present", dateInfo.CurDate, dateInfo.CurTime);
//  make data filename
    makeLogFilename(LogFile, dateInfo.CurDate);
    sprintf(__printbuf, "Data filename: %s\n", LogFile);
    timePrint(__printbuf, dateInfo.CurDate, dateInfo.CurTime);

    timePrint("Getting disk info ...", dateInfo.CurDate, dateInfo.CurTime);

    char buf1[20], buf2[20];

    GetDiskInfo(&diskInfo);
    AddSizeSuffix(buf1, diskInfo.SpaceLeft);
    AddSizeSuffix(buf2, diskInfo.SpaceUsed); 
    sprintf(__printbuf, "SD - Free space: %s Space Used: %s File Count: %d", buf1, buf2, diskInfo.FileCount);
    timePrint(__printbuf, dateInfo.CurDate, dateInfo.CurTime);

    AppendLog("SD ready");

    AppendLogBuffer();
  }  
}

/*
// Add a request to the queue that does not
// original from the remote user 
*/
void AppendLog(const char* message) {
  SDcmd sd;
  
  char buf[DATASIZE];

  sd.cmd = lcAppendLog;
  snprintf(sd.data, 100, "%04.4d %05.5d %s", dateInfo.BootDate, dateInfo.CurTime, message);
  sd.atdate = dateInfo.CurDate;
  strncpy(sd.filename, SYSLOGFILE, 32);
  strncpy(sd.directory, "/", 32);

  AddLocalRequestToQueue(sd);
}

void AppendData(const char* message, const char* filename) {
  
  SDcmd sd;

  sd.cmd = lcAppendData;
  sd.atdate = dateInfo.CurDate;
  strncpy(sd.data, message, 100);
  strncpy(sd.filename, filename, 32);
  strncpy(sd.directory, "/Data", 32);
  AddLocalRequestToQueue(sd);
}

RemoteRequest DecodeJsonRequest(const char * jstext) {

  RemoteRequest rq;
  JsonDocument doc;

  DeserializationError error = deserializeJson(doc, jstext);
  
  Serial.printf("Remote request: %s\n", jstext);

  if (!error) {
    char ipa[15];
    
// basics always present - IP and command no
    strcpy(ipa, doc["ip"]);
    rq.IP.fromString(ipa) ;

    rq.Request      = doc["rq"];
    rq.FileName[0]  = 0;
    rq.Data[0]      = 0;

/*  ensure that only the required tags are looked for in the
    json.  If non present tags are looked for it will cause an 
    error. */
    switch(rq.Request) {
      case lcGetLog: strncpy(rq.FileName, "SysData.Txt", 32);
            break;
      case lcGetFile: strncpy(rq.FileName, doc["fn"], 32);
            break;
      case lcEraseFile: strncpy(rq.FileName, doc["fn"], 32);
            break;
    }

  } else {
    Serial.printf("DecodeJsonRequest(ERROR) - %s\r\n", jstext);
  }
  return rq;
}

// -----------------------------------------------
// ---- CORE 0 CODE -------------------------------
// -----------------------------------------------

void Task2code(void * pvParameters ) {
  uint8_t cnt, core;
  
  core =  xPortGetCoreID();
  ts = (taskShare*) pvParameters;

/*  
    * pop the commands off the queue and process them
    * intil the queue is empty.  There is no return
    * from core 0 but for an empty queue a short delay
    * is needed to prevent the watchdog from tripping.
*/

  do {
    while (cQueue.getCount() > 0) {

  //  extract command from the queue
      remoteRequest = cQueue.pop();
      
      sdc.cmd         = remoteRequest.Request;
      sdc.IP          = remoteRequest.IP;
      sdc.port        = UDPPORT;
      sdc.atdate      = remoteRequest.date;

      // force file location
      if ((sdc.cmd == lcAppendLog) || (sdc.cmd == lcAppendLogBuffer))
        strncpy(sdc.directory, "/", 32);
      else
        strncpy(sdc.directory, "/Data", 32);

      strncpy(sdc.filename, remoteRequest.FileName, 32); 
      strncpy(sdc.data, remoteRequest.Data, 100);
            
      sdActions(&sdc);
    }  
    delay(10);
  } while (true);
}

// -----------------------------------------------

void SetData() {
    sprintf(__printbuf, "%05d %d %02X %02X %02X %02X %02X %02X %02X %02X %02X %02X %d", 
                  dateInfo.CurTime,
                  radio.CHANNEL,
        (uint8_t) radio.DATA[0],
        (uint8_t) radio.DATA[1],
        (uint8_t) radio.DATA[2],
        (uint8_t) radio.DATA[3],
        (uint8_t) radio.DATA[4],
        (uint8_t) radio.DATA[5],
        (uint8_t) radio.DATA[6],
        (uint8_t) radio.DATA[7],
        (uint8_t) radio.DATA[8],
        (uint8_t) radio.DATA[9],
        (int16_t) radio.RSSI);
}

