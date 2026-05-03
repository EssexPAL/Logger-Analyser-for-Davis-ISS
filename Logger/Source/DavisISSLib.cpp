/*
   Last Modified Time: April 24, 2026 at 6:11:53 AM
*/

#include <Arduino.h>
#include "DavisISSLib.h" 
#include "flashLED.h"

static timeval  tv;
static timespec tp;
extern DavisRFM69 radio;
extern uint32_t RXFlashCount;
extern uint32_t SDFlashCount;
extern char __printbuf[PRINTBUFSIZE];
extern TFlashData SysData;
extern DiskInfo diskInfo;
extern volatile DateInfo  dateInfo;
extern WsData wsData;
extern flashLED redLED;
extern flashLED grnLED;

extern Adafruit_BMP280 bmp; // use I2C interface

int32_t getWTTime(char * server);
int32_t GetNTPTime(char * Server);

/* ***************************************
 * On some ESP32 board variants the wifi *
 * will not connect without this.        *
 *****************************************/
void ESP32_enable_wifi() {
  pinMode(0, OUTPUT);
  digitalWrite(0, HIGH);
}

void DumpRadioData(char * s) {
  uint8_t cnt = 0;
  char buf[10]; 

    itoa(dateInfo.CurTime, buf, DEC);
    strcat(s, buf);
    strcat(s, " ");

    while (cnt < 10) {
      itoa(radio.DATA[cnt], buf, HEX);
      strcat(s, buf);
      strcat(s, " ");
    }
}


bool InitBMP280() {
 bool status;
 
  byte tryCount = 5;
  do {
    status = bmp.begin();
    if (!status) {
      delay(250);
      tryCount--; 
    }      
  } while (!status && (tryCount > 0));

  if (status) {
    /* Default settings from datasheet. */
    bmp.setSampling(Adafruit_BMP280::MODE_NORMAL,     /* Operating Mode. */
                    Adafruit_BMP280::SAMPLING_X2,     /* Temp. oversampling */
                    Adafruit_BMP280::SAMPLING_X16,    /* Pressure oversampling */
                    Adafruit_BMP280::FILTER_X16,      /* Filtering. */
                    Adafruit_BMP280::STANDBY_MS_500); /* Standby time. */

  }
  return(status);
}

int16_t getBMPpressure(float correction) {
  
  Adafruit_Sensor *bmp_pressure = bmp.getPressureSensor();
  sensors_event_t pressure_event;
  bmp_pressure->getEvent(&pressure_event);
   
  return((int16_t) ((pressure_event.pressure + correction) * 10));
}

uint8_t AverageWindSpeed(uint8_t Buffer[24]) {
  
  uint16_t avr = 0;

  for (uint8_t i = 0; i < 24; i++) {
    avr += Buffer[i];
  }
    return avr / 24;
}

/*
 * average wind direction for a one minute period.
 *  The samples are at 2.56s intervals (24).
 * The samples are 8 bit quantities (0 -255)
 * so have to be scaled to 360 at the end.
*/

uint16_t AverageWindDir(uint8_t Buffer[24]) {

  const float CORRECTION = WIND_DIR_CORRECTION; // scale factor for 256 to 360
  //const float CORRECTION = 1.40625; // scale factor for 256 to 360
  int16_t avr = 0;
  int16_t j = 0;

    for (uint8_t i = 0; i < 24; i++) {
      if (Buffer[i] > 127) { // equivalent to 180 - 359 degrees
        j = Buffer[i] - 256;
      } else {
        j = Buffer[i];
      }

      avr += j;
    }
    
    avr /= 24;

    if (avr < 0)
      avr += 256;

    return (uint16_t) (avr * CORRECTION); 
}

/* Accepts an array of uint8_t containing eight 
 * bit representations of 360 degrees.  Therefore
 * each value has to be corrected (multiplied by 1.40625)
 * to give 360 degrees. */
double meanAngle (uint8_t *angles, int size) {
   
  double y_part = 0, x_part = 0;
  int i;

  for (i = 0; i < size; i++) {
    x_part += cos ((angles[i] * ANGLECORR) * DEG2RAD);
    y_part += sin ((angles[i] * ANGLECORR) * DEG2RAD);
  }

  return atan2 (y_part / size, x_part / size) * RAD2DEG;
}

bool activateWiFi(WiFiMulti wifiMulti, uint16_t wait, char * ssid_list, char * hostname) {

// remove all fixed IP info
  WiFi.config(INADDR_NONE, INADDR_NONE, INADDR_NONE, INADDR_NONE);
  WiFi.setHostname(hostname); //define hostname

  WiFi.persistent(false);     // no persistent, always needs connection info
  WiFi.mode(WIFI_STA);        // station mode
  WiFi.setSleep(false);       // no wifi modem sleep
  
  char * p = ssid_list;

// build list of connection info
  for (byte entry = 0; entry < SSIDENTRIES; entry++) {
      if (*p != 0) {
        wifiMulti.addAP(p, p + SSIDNAMESIZE);
        sprintf(__printbuf, "Using: %s %s", p, p + SSIDNAMESIZE);
        timePrint(__printbuf, dateInfo.CurDate, dateInfo.CurTime);
      }
    p += (SSIDNAMESIZE + SSIDKEYSIZE);
  }

  int8_t connect_count = 2;
  uint8_t wifiStat = WL_CONNECT_FAILED;

  while (wifiStat != WL_CONNECTED) {
  
    wifiStat = wifiMulti.run(wait); // try connect
  
    if (wifiStat == WL_CONNECTED) {
      sprintf(__printbuf, "WiFi connected as: %s %s RSSI: %ddB", WiFi.SSID().c_str(), WiFi.localIP().toString(), WiFi.RSSI());
    } else
      sprintf(__printbuf, "WiFi NOT CONNECTED! - CODE %d - Retrying", wifiStat);
      
    timePrint(__printbuf, dateInfo.CurDate, dateInfo.CurTime);

    if (wifiStat == WL_CONNECTED)
      break;
    else {
      connect_count--;
      if (connect_count == 0)
        break;
      delay(500);
    }
  }
  return (wifiStat == WL_CONNECTED);
}

bool activateWiFi2(TSSIDLIST IdList, uint16_t wait, TSSIDLIST ssid_list, char * hostname) {

  grnLED.flash(2);
  wait = wait << 2;
// remove all fixed IP info
  WiFi.config(INADDR_NONE, INADDR_NONE, INADDR_NONE, INADDR_NONE);
  WiFi.setHostname(hostname); //define hostname

  WiFi.persistent(false);     // no persistent, always needs connection info
  WiFi.mode(WIFI_STA);        // station mode
  WiFi.setSleep(false);       // no wifi modem sleep
  WiFi.begin(ssid_list.Entry[0].Name, ssid_list.Entry[0].Key);

  Serial.print(" Waiting for Wifi connection ");  
  while (!WiFi.isConnected() && wait > 0) {
    Serial.print('.');
    delay(250);
    wait--;
  }
  grnLED.off();

  uint8_t wifiStat = WL_CONNECT_FAILED;

  if (!WiFi.isConnected() && wait == 0) {
    Serial.println("\nConnection failed");
  } else {
    wifiStat = WL_CONNECTED;
    Serial.println(" Connected");
  }

  if (wifiStat == WL_CONNECTED)  {
      char tbuf1[20];
      char tbuf2[20];
      sprintf(__printbuf, "WiFi connected as: %s %s RSSI: %ddB", WiFi.SSID().c_str(), WiFi.localIP().toString(), WiFi.RSSI());
      timePrint(__printbuf, dateInfo.CurDate, dateInfo.CurTime);

      sprintf(__printbuf, "Wifi low signal indicator threshold %ddB", WIFI_RSSI_THRESHOLD);
      timePrint(__printbuf, dateInfo.CurDate, dateInfo.CurTime);
  }
  
  return (wifiStat == WL_CONNECTED);

}

/* ------------------------------------------------------------
 * Set the time change flags. Called from the timer ISR
 * ------------------------------------------------------------
 * Make the day change after the last SD write of the day.
 * This ensures that the last and first SD writes end up in the
 * files for the correct day. 
 * ------------------------------------------------------------ */
uint8_t getTimeStatus(volatile DateInfo *di) {
    
  uint8_t flags = 0;
  
  if ((di->CurTime >= REBOOT_TIME) && (di->CurTime <= (REBOOT_TIME + 5))) {
    flags = REBOOTNOW;
  }

/* The day change should occur a few seconds after midnight.
 * DO NOT resync the clock at midnight.  If the internal
 * clock has drifted backwards then you will pass midnight
 * twice and the date will be wrong. */

  if (di->CurTime >= 86405) { // whole day change, 5s past midnight
    flags |= DAYCHANGE;
  }
  
  if ((di->CurTime % 3600) == 0) { // hour change
    flags |= HRSCHANGE;
  } 
  
  if (di->CurTime % 60 == 0) { // min change
      flags |= MINCHANGE;
      if ((di->CurTime % 600) == 0) { // ten min change
        flags |= TENMINCHANGE;
      }
  }

  return flags;
}

float MPHtoKPH(uint16_t mph) {
  return mph * 1.60934;
}

uint16_t FahrenheittoCelcius(float Fahrenheit) {
   return round((float)(Fahrenheit - 32) * 0.555555f); 
}

void makeLogFilename(char * LogFile, uint16_t date) {
  word d, m, y;

  DecodeDate(&d, &m, &y, date);
  sprintf(LogFile, "/Data/WsData%02d%02d%02d.dat", y % 100, m, d);
}


// Check flags and act accordingly
void MinuteCheck(char * LogFile, volatile DateInfo *di, WsData *wsd, RFMPacketStats ps) {
    
  char buf[140];
  tm nt;

/*  Check the time at 630 seconds (10:30) past each hour.  
    If it is less than 20s in error then correct the
    system time.  This prevents double or missing one
    minute samples. By using a 630 second check
    it mean a fairly quick time recheck after the 
    03:00 reboot. */

  if (di->CurTime % 3600 == 630) {
    Get_ESP_NTP_Time(&nt);
    int8_t diff = abs(int(di->CurTime - nt.tm_wday));
    if ((diff > 0) && (diff < 20)) {
      di->CurTime = nt.tm_wday;
      sprintf(buf, "Time updated - Diff: %d", diff);    
      timePrint(buf, dateInfo.CurDate, dateInfo.CurTime);
    }
  }

  if ((di->TimeFlags & REBOOTNOW) > 0) {
//    ensure the RAM CRC is up to date before reboot     
      wsData.Other.dataCRC = calcCRC32((uint8_t *) &wsData, WSDATA_CRC_BYTE_COUNT);
      
   /* "if (wsd->Other.lastRBdate != di->CurDate)" stops a
     * a second reboot in a day.  This is possible if the
     * time after reboot is earlier than the time before reboot. */
    if (wsd->Other.lastRBdate != di->CurDate) {
      wsd->Other.lastRBdate = di->CurDate;

      timePrint(">>> ------ <<<", dateInfo.CurDate, dateInfo.CurTime);
      timePrint(">>> REBOOT <<<", dateInfo.CurDate, dateInfo.CurTime);
      timePrint(">>> ------ <<<", dateInfo.CurDate, dateInfo.CurTime);

      AppendLogBuffer();
      delay(100);
      ESP.restart();
    }
  }

//  do the hour change before the day change
  if ((di->TimeFlags & HRSCHANGE) == HRSCHANGE) {
    wsd->TotalHourRain = 0;
    sprintf(__printbuf, "Hourly rain cleared %02d:00", di->CurTime / 3600);
    timePrint(__printbuf, dateInfo.CurDate, dateInfo.CurTime);
  }

  if ((di->TimeFlags & DAYCHANGE) == DAYCHANGE) {
      wsd->TotalDayRain   = 0;
      wsd->TotalHourRain  = 0;
      di->CurTime = di->CurTime % 86400;
      di->CurDate++;

      makeLogFilename(LogFile, dateInfo.CurDate);
      sprintf(__printbuf, "Data filename: %s", LogFile);
      timePrint(__printbuf, dateInfo.CurDate, dateInfo.CurTime);

//    Show the packet stats at midnight
      Dump_Packet_Stats(ps, true);
      TimeToString2(buf, di->CurTime, di->isSummer);

//    make the new filename for the data
      makeLogFilename(LogFile, di->CurDate);
      sprintf(__printbuf, "Data filename: %d %s %s\r\n", 
                            di->SecondsElapsed, 
                            buf, 
                            LogFile);
      timePrint(__printbuf, dateInfo.CurDate, dateInfo.CurTime);
  }
      
  if ((di->TimeFlags & TENMINCHANGE) == TENMINCHANGE) {
    wsd->PkWindSpeed = 0;
  }
  
  if ((di->TimeFlags & MINCHANGE) == MINCHANGE) {
    wsd->TotalMinRain = 0; 
  }

  di->TimeFlags = 0;
}

void Dump_Packet_Stats(RFMPacketStats ps, bool showtime) {
  char buf[100];
  uint8_t i;
  uint8_t valuecount = 0;

  sprintf(__printbuf, "%19s %d",          "Total Packets:",   ps.packetsReceived);
  timePrint(__printbuf, dateInfo.CurDate, dateInfo.CurTime);
// -----------------------------------------------------------------------
  sprintf(__printbuf, "%19s %d",          "CRC Errors:",      ps.crcErrors);
  timePrint(__printbuf, dateInfo.CurDate, dateInfo.CurTime);
// -----------------------------------------------------------------------
  sprintf(__printbuf, "%19s %d",          "Lost Packets:",  ps.packetsMissed);  
  timePrint(__printbuf, dateInfo.CurDate, dateInfo.CurTime);
}


uint8_t ByteCompare(char * out, char * src1, char * src2) {

  uint8_t idx = 0;
  char buf[25];
  bool mismatch = false;
  uint8_t failcount = 0;

  out[0] = 0;

  while ((src1[idx] != 0) && (src2[idx] != 0)) {
    if (src1[idx] != src2[idx]) {
      failcount++;
      sprintf(buf, "%02d ", idx / 6);
      strcat(out, buf);
      mismatch = true;
    }
    idx++;
  }

  if(!mismatch)
    strcpy(out, "NONE");

  return failcount;
}

bool CheckData(WsData * Data) {

    return (calcCRC32((uint8_t *) Data, WSDATA_CRC_BYTE_COUNT) == Data->Other.dataCRC);
}

/* init the contents of the WsData structure and set CRC
*/
void fillData(WsData * Data) {

//  WsData     
    Data->AvWindSpeed           = 0;
    Data->PkWindSpeed           = 0;
    Data->AvWindDir             = 0;
    Data->Temperature           = 0;
    Data->Humidity              = 0;
    Data->TotalDayRain          = 0;
    Data->TotalHourRain         = 0;
    Data->TotalMinRain          = 0;
    Data->Pressure              = 0;
    Data->RSSI                  = 0;
    memset(Data->WindDir, 0, 24);
    memset(Data->WindSpd, 0, 24);
    Data->Index                 = 0;
//  ---------------------------------
//  WsOther    
    Data->Other.BatteryStatus   = true;
    Data->Other.LastTip         = 0xFF;
    memset(Data->Other.sdBuffer, 0, 100);
    Data->Other.dataCRC = calcCRC32((uint8_t *)Data, WSDATA_CRC_BYTE_COUNT);
    Data->Other.lastRBdate      = 0;
    Data->Other.rebootCount     = 3;
}

