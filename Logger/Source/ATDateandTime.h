/*
   Last Modified Time: April 2, 2026 at 10:13:29 AM
*/

#include <Arduino.h>

#ifndef ATDATEANDTIME_
#define ATDATEANDTIME_

#define MAX_NET_TRIES 10 // for time collection

#include <HTTPClient.h>
#include <ArduinoJson.h>
#include "ATDateandTime.h"
#include <esp_sntp.h>

struct __attribute__((packed)) DateInfo
{
    uint8_t     SecondsElapsed = 0;
    uint32_t    CurTime        = 0;
    uint16_t    CurDate        = 0;
    uint8_t     TimeFlags      = 0;
    boolean     isSummer       = false;
    boolean     useDST         = true;
    uint32_t    BootTime       = 0;
    uint16_t    BootDate       = 0;
    boolean     secondFlag     = false; 
    uint32_t    lastSave       = 0; 
};

struct __attribute__((packed)) ntpTime
{
    uint32_t Sv; // second count from 01/01/1970
    uint32_t uSv; // microsecond count
};


/* 	WARNING - This same (exactly the same) definition is used in 
	DavisISSLib.h.  Ensure that both remain unaltered!! 

	MOVED TO CommonDefs.h

	struct __attribute__((packed)) DateInfo
	{
	    uint8_t     SecondsElapsed = 0;
    	uint32_t    CurTime        = 0;
	    uint16_t    CurDate        = 0;
    	uint8_t     TimeFlags      = 0;
	    boolean     isSummer       = false;
    	boolean     useDST         = true;
	    uint32_t    BootTime       = 0;
    	uint16_t    BootDate       = 0;
	    boolean     secondFlag     = false; 
    	uint32_t    lastSave       = 0; 
		};
	}
*/

	word EncodeDate(int d, int m, int y);
	long EncodeTime(word h, word m, word s);
	void DecodeDate(word *d, word *m, word *y, word TheDate);
	void DateToString(char * buf, word DateTime);
	void DateTimeToString(char * buf, int Date, unsigned long Time, bool dst);
	word StringToDate(const char * buf);
	
	void DecodeTime(long tm, word *h, word *m, word *s, bool dst);
	void TimeToString(char * buf, unsigned long tm, bool dst);
	void TimeToString2(char * buf, unsigned long tm, bool dst);
	
	long StringToTime(const char * buf);
	void DateTimeToString(char * buf, int Date, unsigned long Time, bool dst);
	bool IsDSTActive(word dt, long tm, bool DSTinUse, bool show);
	bool IsDSTActive1(word dt, long tm, bool DSTinUse, bool show);
	void SetDST(bool dst);
	bool GetDST();
	byte DayOfWeek(word dt);

//	functions for collecting date and time from WorldTime or NTP
//	getSystemDateTime() is the primary function to use
	bool 	getSystemDateTime(volatile DateInfo * di, char * server, char * msg);
	uint8_t getNetworkTime(char * srv, tm * dt, uint8_t Tries);
	
	uint64_t Init_ESP_SNTP(char * Server, int32_t Offset_From_UTC, int32_t DST_Offset, bool useDST);
	ntpTime Get_ESP_NTP_Time(tm * timeinfo);
	ntpTime Get_ESP_NTP_Time(tm * timeinfo, int32_t dst_offset);

	bool 	getWTDateTime(char * server, tm * ddt);
	int32_t GetNTPTime(char * Server);
	bool 	getWorldTime(char * srv, tm * dt, uint8_t Tries);
	int32_t getWTTime(char * server);

#endif



