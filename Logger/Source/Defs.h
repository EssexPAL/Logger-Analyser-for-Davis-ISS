/*
   Last Modified Time: April 24, 2026 at 6:34:26 AM
*/

#ifndef DEFS_H
#define DEFS_H

#define WIFI_RSSI_THRESHOLD        -80 // (dBm) RF level at which a low signal indication shows

#define SERIAL_BAUD             115200 // Davis console is 19200 by default
#define DATAFOLDER              (char *) "/Data"
#define NTP_SERVER              (char *) "pool.ntp.org\0"
#define MAX_TRIES                  10 

//#define LOG_MAX_CHARS            1024
#define REBOOT_HOURS               03
#define REBOOT_MINS                00
#define REBOOT_SECS                05   
#define REBOOT_TIME             (REBOOT_HOURS * 3600) + (REBOOT_MINS * 60) + REBOOT_SECS

#define SYSLOGFILE              (char *)"SysLog.Txt\0"
#define DEFAULT_HOSTNAME        (char *)"WS_LOGGER\0"

#define LOG_MAX_SIZE             1000000

#define WIND_DIR_CORRECTION    1.40625 // scale factor for 256 to 360 degrees
#define _APORT                    2010  // <-----------

#define PRINTBUFSIZE             256   
#define BMP_ENABLE                5  // GPIO NUMBER

#define FAIL_THRESHOLD            5  

// temporary correction for test purposes only
const float CORRECTION          = 6.8;


#endif // DEFS_H