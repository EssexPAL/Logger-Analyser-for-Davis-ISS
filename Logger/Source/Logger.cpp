/*
   Last Modified Time: April 13, 2026 at 9:51:15 PM
*/

#include <Arduino.h>
#include "Logger.h"

#define LOG_MAX_CHARS 1024
#define MINLOGLENGTH 100

struct SystemLog
{
    char Text[LOG_MAX_CHARS];
    uint16_t used;
};

SystemLog SysLog;

/* write the message into the log buffer provided there is space*/
void timePrint(const char * msg, uint16_t date, uint32_t time) {
  char tpbuf[256];
  char buf[256];
  uint16_t MsgLen;
  uint32_t thetime;

  if (SysLog.used == 0)
    SysLog.Text[0] = 0;

//   The time info depends upon whether the clock has been set to NTP yet
    if (date < 100) 
        thetime = millis();
    else
        thetime = time;
    
    sprintf(tpbuf, "%5d %5d (%8d) %s\r\n", date, thetime, millis(), msg);

  // Determine if there is space in the buffer
  // for the message */
    
    MsgLen = strlen(tpbuf);
    Serial.print(tpbuf);
    
  if ((SysLog.used + MsgLen) < LOG_MAX_CHARS) {
    SysLog.used += MsgLen;
    strcat(SysLog.Text, tpbuf);
  }
}


// Return true if the log needs to be flushed
bool NeedToFlushLog() {
  return SysLog.used > (LOG_MAX_CHARS - MINLOGLENGTH);
}

// get the log and zero the use count
char* GetLog() {
//  SysLog.used = 0;
  return SysLog.Text;
}

uint16_t GetLogSize() {
  return SysLog.used;
}

void ClearLog() {
  SysLog.Text[0] = 0;
  SysLog.used = 0;
}

void TouV(int16_t value, char * Buffer) {
  Buffer[0] = 0;
  float e;
  char sub[5];
  const float V_ZERODBM = 0.2236; // volts (1mW into 50ohms)

  strcpy(sub, "mV");
  e = (V_ZERODBM / pow(10, (abs(value) / 20))) * 1000; // to mV

  if (e < 1) {
    e = e * 1000; // show uV
    strcpy(sub, "uV");
  }

  sprintf(Buffer, "%4.0f%s", round(e), sub);
  
}

char * boot_reasons [] = {
    (char*) "UNKNOWN",              // Reset reason can not be determined
    (char*) "POWER ON",             // Reset due to power-on event
    (char*) "EXT PIN",              // Reset by external pin (not applicable for ESP32)
    (char*) "SOFTWARE RESTART",     // Software reset via esp_restart
    (char*) "EXCEPTION",            // Software reset due to exception/panic
    (char*) "INTERRUPT WDT",        // Reset (software or hardware) due to interrupt watchdog
    (char*) "TASK_WDT",             // Reset due to task watchdog
    (char*) "ESP RESET WDT",        // Reset due to other watchdogs
    (char*) "AFTER_DEEP SLEEP",     // Reset after exiting deep sleep mode
    (char*) "AFTER BROWNOUT",       // Brownout reset (software or hardware)
    (char*) "RST FROM SDIO",        // Reset over SDIO (SPI)    
};

char* GetBootReason(uint8_t brc) {
  return boot_reasons[brc];
}