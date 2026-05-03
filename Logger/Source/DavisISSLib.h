/*
   Last Modified Time: April 24, 2026 at 6:26:26 AM
*/

#ifndef DAVISISSLIB_h
#define DAVISISSLIB_h

#include <Arduino.h>
#include <ArduinoJson.h>
#include <WiFi.h>
#include <WiFiMulti.h> 
#include <DavisRFM69.h>
#include <time.h>
#include <sys/time.h>
#include <DavisRFM69.h>
#include <WiFi.h>
#include <Adafruit_BMP280.h>
#include <string.h>
#include <CRC32.h>
#include <CRC.h>
#include <esp_sntp.h>
#include "ISSFlash.h"
#include "Defs.h"
#include "CommonDefs.h"
#include "Logger.h"
#include "SDFunctions.h"

#define TEMPDATA 0x8
#define HUMIDATA 0xA
#define RAINDATA 0xE
    
#define DAYCHANGE       0x01
#define HRSCHANGE       0x02
#define MINCHANGE       0x04
#define TENMINCHANGE    0x08
#define REBOOTNOW       0x10  

// led IO definitions
#define LED_RED   32
#define LED_GRN   34

const double DEG2RAD    = M_PI / 180;     // degrees to radians
const double RAD2DEG    = 180 / M_PI;     // radians to degrees
const double ANGLECORR  = 360.0 / 256.0;  // correct to make 255 = 360 degrees

uint8_t     getTimeStatus(volatile DateInfo *di);

void        MinuteCheck(char * LogFile, volatile DateInfo *di, WsData *wsd, RFMPacketStats ps);
uint16_t    FahrenheittoCelcius(float Fahrenheit);
float       MPHtoKPH(uint16_t mph);
void        makeLogFilename(char * LogFile, uint16_t date);
void        Dump_Packet_Stats(RFMPacketStats ps, bool showtime);

uint8_t     ByteCompare(char * out, char * src1, char * src2);
bool        activateWiFi(WiFiMulti wifiMulti, uint16_t wait, char * ssid_list, char * hostname);
bool        activateWiFi2(TSSIDLIST IdList, uint16_t wait, TSSIDLIST ssid_list, char * hostname);

uint8_t     AverageWindSpeed(uint8_t Buffer[24]);
uint16_t    AverageWindDir(uint8_t Buffer[24]);
double      meanAngle (uint8_t *angles, int size);

bool        InitBMP280();
int16_t     getBMPpressure(float correction);

bool        CheckData(WsData * Data);
void        fillData(WsData * Data);

void        DumpRadioData(char * s);

void        ESP32_enable_wifi();


#endif  // DAVISISSLIB_h


