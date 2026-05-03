/*
   Last Modified Time: March 11, 2026 at 5:09:13 PM
*/

#include <Arduino.h>
#include "Menu.h"

const char * On_Off[2] = {"Off", "On"};

char SerialBuf[SERIALBUFFERSIZE];

extern TFlashData SysData;
extern TSSIDLIST SsidList;

extern DateInfo dateInfo;
extern DavisRFM69 radio;
extern char __printbuf[PRINTBUFSIZE];
extern RFMPacketStats packetStats;
//extern const char * FW_VERSION;

bool DoMenu(char* inbuf);
void ShowMenu();
char buf[200];

// incoming strings maybe incomplete so hold the string outside of
// serialEvent() until they are complete
word SerialPos;

/* ------------------------------- */

void clearSerialBuffer(void) {
  memset(SerialBuf, 0, SERIALBUFFERSIZE);
}

// trim white space from the end of the buffer
void trimRhWhiteSpace(char* buf, int8_t len) {

  uint16_t p = len - 1;

  while (*(buf + p) < 0x21) { // trim up to the last visible non-space character
    if(*(buf + p) <= 0x20) 
      *(buf + p) = 0;
    p--;
  }
}


void MakeSpace(byte Lines) {
  for(byte i = 0; i < Lines;i++) {
    Serial.println("");
  }
}

//something wrong here - returns invalid option
void serialEvent() {
  char ch;

  if (Serial.available()) {
    do {
      ch = Serial.read();
      SerialBuf[SerialPos++] = ch;
      SerialBuf[SerialPos] = 0;
    } while ((Serial.available() > 0) && (SerialPos < 64));
  }

  if(ch == 0x0A) {
    if (strlen(SerialBuf) > 0)
      if (DoMenu(SerialBuf))
        WriteFlashData(&SysData, &SsidList, false);
    
    Serial.flush();
    SerialBuf[0] = 0;
    SerialPos = 0;
  }
}

//void DumpSystemData(TFlashData Fd, TSSIDLIST Sd, PacketStats ps, boolean showtime) {
void DumpSystemData(TFlashData Fd, RFMPacketStats ps, boolean showtime) {
  const char * YesNo[2] = {"No", "Yes"};
  char tbuf[40];
  char pb[150];

  timePrint("\r\n", dateInfo.CurDate, dateInfo.CurTime);

  sprintf(pb, "%19s %s",                      "FIRMWARE:",    FW_VERSION);
  timePrint(pb, dateInfo.CurDate, dateInfo.CurTime);

  sprintf(__printbuf, "%19s %s",                "Header:",      Fd.Header);
  timePrint(__printbuf, dateInfo.CurDate, dateInfo.CurTime);

  sprintf(__printbuf, "%19s %2dm (%4ds)",   "UTC Offset:",  Fd.UTC_Offset / 60, Fd.UTC_Offset);
  timePrint(__printbuf, dateInfo.CurDate, dateInfo.CurTime);

  sprintf(__printbuf, "%19s %2dm (%4ds)",   "DST Offset:",  Fd.DST_Offset / 60, Fd.DST_Offset);
  timePrint(__printbuf, dateInfo.CurDate, dateInfo.CurTime);

  sprintf(__printbuf, "%19s %s (%d)",         "Use DST:",     YesNo[Fd.UseDST], Fd.UseDST);
  timePrint(__printbuf, dateInfo.CurDate, dateInfo.CurTime);

  DateTimeToString(tbuf, dateInfo.CurDate, dateInfo.CurTime, dateInfo.isSummer);
  sprintf(__printbuf, "%19s %s",            "Date/Time:",   tbuf);
  timePrint(__printbuf, dateInfo.CurDate, dateInfo.CurTime);

  int16_t rad_rssi = radio.RSSI;
  int16_t wifi_rssi = WiFi.RSSI();
    
  if (rad_rssi == 0)
    rad_rssi= -120;

  if (wifi_rssi == 0)
    wifi_rssi= -120;

  sprintf(__printbuf, "%19s %s",              "Hostname:", SysData.hostName);
  timePrint(__printbuf, dateInfo.CurDate, dateInfo.CurTime);

  sprintf(__printbuf, "%19s %s as %s",        "Connected to:", WiFi.SSID().c_str(), WiFi.localIP().toString());
  timePrint(__printbuf, dateInfo.CurDate, dateInfo.CurTime);

  TouV(rad_rssi, tbuf);
  sprintf(__printbuf, "%19s %4d dBm %s",      "ISS Receiver RSSI:", rad_rssi, tbuf);
  timePrint(__printbuf, dateInfo.CurDate, dateInfo.CurTime);

  TouV(wifi_rssi, tbuf);
  sprintf(__printbuf, "%19s %4d dBm %s\r\n",  "WiFi Receiver RSSI:", wifi_rssi, tbuf);
  timePrint(__printbuf, dateInfo.CurDate, dateInfo.CurTime);

  Dump_Packet_Stats(ps, showtime); // packet stat dump
}

bool DoMenu(char* inbuf) {
  
  bool retval = false;
  char sc = ' ';
  int32_t buflen = 0;

// strip off terminating control characters,
// make it upper case and find length
  uint8_t Idx = 0;
  while (inbuf[Idx] >= 0x20)
    Idx++;
  
  inbuf[Idx] = 0;
  inbuf[0] = toupper(inbuf[0]);
  buflen = strlen(inbuf);

// remove any trailing white space
  trimRhWhiteSpace(inbuf, SERIALBUFFERSIZE);

  switch(inbuf[0]) {
    case '?': ShowMenu(); // help
              break;
    case 'H': if (buflen > 5) {
                sscanf(inbuf + 1, "%s", SysData.hostName);
                retval = true;
              }
              Serial.printf("Hostname: %s\r\n",  SysData.hostName);
              break;
    case 'A': if (buflen > 5) { // now only handles a single SSID (SsidList.Entry[0])
                if (inbuf[1] == ' ') {
                  sscanf(inbuf + 1, "%s %s", SsidList.Entry[0].Name, SsidList.Entry[0].Key);
                  retval = true;
                }                
              }
              Serial.printf("SSID: %s Key: %s\r\n", SsidList.Entry[0].Name, SsidList.Entry[0].Key);
              break;
    case 'D': if (buflen > 1) {
                inbuf[1] = toupper(inbuf[1]);
                switch(inbuf[1]) {
                case 'F': DumpFlashData("Flash Data");
                          break;
                case 'S': DumpSystemData(SysData, packetStats, false);
                          break;
                case 'R': char buf[300];
                          Serial.println("\r\nRFM69 Registers 01 - 4F\r\n");
                          radio.readAllRegs(buf);
                          Serial.println(buf);
                          break;
                }
                MakeSpace(2);
              } 
              break;
    case 'I': if (buflen > 2) 
                if (strncmp(inbuf, "I Yes", 5) == 0) { // re-init the flash area and restart
                  InitFlash();
                  Serial.println("Flash re-initialised - configuration lost!\r\n");
                  ESP.restart();
                }
              break;
    case 'M': ShowMenu(); // help
              break;
      case 'R': if (buflen > 2)
                if (strncmp(inbuf, "R Yes", 5) == 0) { // restart the app
                  ESP.restart();
                }
              break;
    case 'Z': if (buflen > 5) {
                if(inbuf[1] == ' ') {
                  sscanf(inbuf + 1, "%s %d %d", SsidList.Entry[1].Name, &SysData.UTC_Offset, &SysData.DST_Offset);
                  SysData.UseDST = SysData.DST_Offset != 0;
                  retval = true;
                }
              }
              Serial.printf("NTP Settings: %s %d %d\r\n", SsidList.Entry[1].Name, SysData.UTC_Offset, SysData.DST_Offset);
              break;
    default:  Serial.println("Not a valid option!\r\n");
              break;
  }
  return retval;
}

//#endif

void ShowMenu() {
  MakeSpace(5);
  Serial.println("Menu options");
  Serial.println("");
  Serial.println("?           - Display help");
  Serial.println("---------------------");
  Serial.println("A           - Show SSID and Key");
  Serial.println("A SSID Key  - Set SSID and Key");
  Serial.println("---------------------");
  Serial.println("H           - Display Hostname");
  Serial.println("H Hostname  - Set Hostname");
  Serial.println("---------------------");
  Serial.println("I Yes       - Re-initialise Flash memory");
  Serial.println("Df          - Display flash data");
  Serial.println("Ds          - Display system data");
  Serial.println("Dr          - Display RFM69 registers");
  Serial.println("R Yes       - Restart the ESP");
  Serial.println("---------------------");
  Serial.println("Z - Set the parameters for your timezone");
  Serial.println("The first parameter is the NTP server address");
  Serial.println("The second parameter is your timezone's offset in seconds from UTC");
  Serial.println("The third parameteris the DST offset in seconds");
  Serial.println("Example (UK) Z pool.ntp.org 0 3600");
  Serial.println("Example (Singapore) Z pool.ntp.org 28800 0");
  Serial.println("Example (Barbados) Z pool.ntp.org -14400 0");
  Serial.println("Example (Alaska) Z pool.ntp.org -32400 3600"); 

  Serial.println("");
  }

  