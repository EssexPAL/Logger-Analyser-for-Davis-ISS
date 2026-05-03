/*
   Last Modified Time: April 24, 2026 at 10:40:44 PM
*/

    /* Common definitions which cross more than one appication */

#ifndef COMMONDEFS_H
#define COMMONDEFS_H

#include <Arduino.h>

#define FW_VERSION              (char *) "1.20.3_(24/04/26)\0"
/* 
    1.15.5 Changes  - 27/11/2025 -  First version using platformio
                                    RFM69 Changed to allow use of both SPI's
                                    RFM69 Moved to VSPI
                                    SD Moved to HSPI
*/

// Define HSPI pins - SD
static const uint8_t HSD_SCK =  14; // OK
static const uint8_t HSD_MISO = 25; // default is 12 which is a strapping pin
static const uint8_t HSD_MOSI = 13; // OK
static const uint8_t HSD_CS   = 26; // OK default is 15 which is a strapping pin


// Define VSPI pins - RFM
static const uint8_t VSD_SCK  = 18;
static const uint8_t VSD_MISO = 19;
static const uint8_t VSD_MOSI = 23;
static const uint8_t VSD_CS   =  4;

struct __attribute__((packed)) WsOther
{
// ---DATA THAT WILL BE RETAINED ---	
//                              Bytes   Position
    bool        BatteryStatus;  // 1    43
    uint8_t     LastTip;        // 1    44  Last tip count
    char        sdBuffer[64];   // 64   45  only 46 chars should be used
    uint32_t    dataCRC;        // 4    85
    uint32_t    lastRBdate;     // 4    89  last reboot date
    int8_t      rebootCount;    // 1    90
};

struct __attribute__((packed)) WsData
{
// ---DATA THAT WILL BE RETAINED and checksummed ---
//                              Bytes   Position
    uint16_t    AvWindSpeed;    //  2  0 - running average of wind speed (2.5s)
    uint8_t     PkWindSpeed;    //  1  2 - peak speed in last 10 minutes
    int16_t     AvWindDir;      //  2  3 - running average of wind direction (2.5s)
    uint16_t    Temperature;    //  2  5 - current temperature x 10 degrees F (10s)
    uint16_t    Humidity;       //  2  7 - curent humidity (50s)  
    uint16_t    TotalDayRain;   //  2  9 - max spoon tip count, reset every 24 hours          
    uint16_t    TotalHourRain;  //  2  B - one hour spoon tip count, reset every 60m          
    uint8_t     TotalMinRain;   //  1  D - RAIN RATE - one min spoon tip count, reset every 60s
    uint16_t    Pressure;       //  2  E - Barometric pressure read from BMP sensor
    int16_t     RSSI;           //  2 10 - Running average of RSSI
    uint8_t     WindDir[24];    // 24 12 - array of wind dir samples, enough to hold 60s (as degrees)
    uint8_t     WindSpd[24];    // 24 2A - array of wind speen samples, enough to hold 60S
    uint8_t     Index;          //  1 42 - array index
//                         Total:  67
    // ------------------------------
    WsOther     Other;           // 74 non-CRC data
};  

const uint8_t WSDATA_CRC_BYTE_COUNT = sizeof(WsData) - sizeof(WsOther);

struct __attribute__((packed)) DiskInfo
{
    uint16_t FileCount = 0;
    uint64_t SpaceUsed = 0;
    uint64_t SpaceLeft = 0;   
    boolean  sdActive = false;   
};

struct __attribute__((packed)) LiveData
{
    uint16_t    WindSpeed;    // Wind speed (2.5s)
    int16_t     WindDir;      // Wind direction (2.5s)
    uint16_t    Temperature;  // Temperature x 10 degrees F (10s)
    uint16_t    Humidity;     // Humidity (50s)  
    uint16_t    HourlyRain;   // Spoon tip per hour
    uint16_t    Pressure;     // Barometric pressure x 10
    int16_t     RSSI;         // Running RSSI  
};

struct __attribute__((packed)) RFMPacketStats
{
  uint16_t packetsReceived;
  uint16_t packetsMissed;
  uint16_t receivedStreak;
  uint16_t crcErrors;
  bool     syncLost;
  uint32_t packetperiod;
  uint8_t  failCount;
  bool     packetReady;
};

#endif // COMMONDEFS_H
