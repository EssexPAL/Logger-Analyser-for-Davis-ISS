/*
   Last Modified Time: April 24, 2026 at 9:21:24 PM
*/

/* 
 * Date encoding and decoding is from Jan 1st 2000.  These routines will only work
 * until December 31st 2199 as there is no "mod 100" or "mod 400" included.  The encoded
 * date is returned in a word so this limits the date value to 2178.
 *
 * Date 0 = 01/01/2000 -  Zero must be the start because of div and mod arithmetic 
 * wont work otherwise.
 *
 * WARNING - The time routines use the long type.  When converting a long to something smaller
 * it MUST already be within the range that the new type supports.  
*/	
#include <Arduino.h>
#include "ATDateandTime.h"

#define FOURYEARS   1461 // number of days in four years, starting with a Leap Year 
//#define DSTFLAG 	0x20000L // flags dst in use

const word DaysInMonth[12] 	= {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
const word YearDays[4] 		= {366, 365, 365, 365};
bool  _DST_Active; // local dst in use flag, set by the SetDST() function;	
int32_t   _Offset_From_UTC = 0;
int32_t   _DST_Offset = 0;
bool      _Use_DST = false;

void SetDST(bool IsDst) {
	_DST_Active = IsDst;
}

bool GetDST() {
	return _DST_Active;	
}

// dd/mm/yyyy"
// 0123456789
// The date value starts from zero where 0 = 01/01/2000
// Modified 28/10/2021 to allow for NTP dates (i.e. starting at 1900)
void DecodeDate(word *d, word *m, word *y, word TheDate) {	
  int FourYearBlocks = (TheDate / FOURYEARS);
  int Yr, MonD;
  boolean Dn;
  char buf[32];
    
  *y = FourYearBlocks * 4;
  *d = TheDate - (FourYearBlocks * FOURYEARS) + 1;
  
  Yr = 0;  
  while ((Yr < 4) and (*d > YearDays[Yr])) {
    *d -= YearDays[Yr];
    (*y)++;
    Yr++;
  }

  *y += 2000;

  *m = 1;
  Dn = false;
  
  do {
    MonD = DaysInMonth[*m-1];
    if ((Yr == 0) & (*m == 2)) {
        MonD = 29;
	  }

    if (*d > MonD) {
      *d -= MonD;
	    (*m)++;
    } else {	
      Dn = true;
	  } 
  }
  while (!Dn	);
}

// Date 01/01/2000 = 0
word EncodeDate(int d, int m, int y) {
  int noly, nonly, encdate;

	d %= 32;
	m %= 13;
	y %= 100;

  if (y >= 2000) {
    y -= 2000;
  }
	
  encdate = 0;

  if (y > 0 ) {

  // calculate the number of leap years preceeding the current year
	noly = ((y - 1) / 4) + 1;
  // calculate the number of non leap years preceeding the current year
	nonly = y - noly;
  // calculate the number days up the end of the preceeding year
	encdate = (noly * 366) + (nonly * 365);
  }

// add the days for each preceeding month of the current year
//  m = 1;
  int mon = 1;
  while (mon < m) {
    encdate += DaysInMonth[mon -  1];
    mon++;
  }

  // add the leap day
  if (((y % 4) == 0) && (m > 2)) {
    encdate++;
  }

  // add the day of the month
  encdate += (d - 1);

  return encdate;
}

long EncodeTime(word h, word m, word s) {
	long Val;
		
	h %= 24;
	m %= 60;
	s %= 60;
		
    Val = ((h * 3600L) + (m * 60L) + s);
	return Val;
}

// decode time using the dst flag to display the correct hour
void DecodeTime(long tm, word *h, word *m, word *s, bool dst) { // ???????????????
  long tl;


  // decode time
  tl = tm / 3600L;  			// h = hours
  *h = tl;						// get the value into into range
 
 // *m = word(tm - (*h * 3600L)); 	// m = remainder after hours are removed (m & s) 
  *m = tm - (*h * 3600L); 	// m = remainder after hours are removed (m & s)
  *s = *m % 60;					// s = just seconds				
  *m /= 60;						// h = just mins
  
  if (dst)
	  h++;
  if (*h > 23)
	  h = 0;
}

// dd/mm/yyyy"
// 0123456789
// 1 = 01/01/2000
word StringToDate(const char * buf) {
  boolean OK = true;
	word d = 0, m, y;
  char xbuf[5];

  if ((strlen(buf) == 10) && (buf[2] == '/') && (buf[5] == '/')) {

    strncpy(xbuf, buf + 0, 2);
    xbuf[2] = 0;
    d = atoi(xbuf);
		
    strncpy(xbuf, buf + 3, 2);
    xbuf[2] = 0;
    m = atoi(xbuf);

    strncpy(xbuf, buf + 6, 4);
    xbuf[4] = 0;
    y = atoi(xbuf);
	
	  if (y >= 2000)
	    y -= 2000;
	
	  d = EncodeDate(d, m, y);
	}
  return d;
}

void DateToString(char * buf, word DateTime) {
  word d, m, y;
//  int d, m, y;
  
  DecodeDate(&d, &m, &y, DateTime);
  sprintf(buf, "%2.2d/%2.2d/%4.4d", d, m, y);
}

//"nn:nn:nn"
// 01234567
long StringToTime(const char * buf) {
  boolean OK = true;
  int h, m, s;
  char xbuf[5];
  long Val;

// check length and format "00:00:00"
  if ((strlen(buf) == 8) && (buf[2] == 0x3A) && (buf[5] == 0x3A)) {
 
    strncpy(xbuf, buf + 0, 2);
    xbuf[2] = 0;
    h = atoi(xbuf);

    strncpy(xbuf, buf + 3, 2);
    xbuf[2] = 0;
    m = atoi(xbuf);

    strncpy(xbuf, buf + 6, 2);
    xbuf[2] = 0;
    s = atoi(xbuf);

    Val = EncodeTime(h, m, s);
	return Val;
  } else {
	  return -1;
  }
}

// time is always stored without dst correction
void TimeToString(char * buf, unsigned long tm, bool dst) {
  word h, m, s;
//  unsigned char *dsts[2] = {0x00, 0x2A};
  
  *buf = 0;
  tm %= 86400;	
  DecodeTime(tm, &h, &m, &s, dst);
  
  if (dst)
	h++;
    
  if (h > 23)
    h = 0;  
   
//  sprintf(buf, "%s%2.2u:%2.2u:%2.2u", dsts[dst], h, m, s);
  sprintf(buf, "%2.2u:%2.2u:%2.2u", h, m, s);
  buf[9] = 0;
//  DebugSendString(buf, true);
}

// dst is only marked, no adjustment to hours
void TimeToString2(char * buf, unsigned long tm, bool dst) {
  word h, m, s;
  char dsts[2] = {0x20, 0x2A};
  
  *buf = 0;
  tm %= 86400;	
  DecodeTime(tm, &h, &m, &s, dst);
   
  sprintf(buf, "%c%2.2u:%2.2u:%2.2u", dsts[dst], h, m, s);
  buf[9] = 0;
}

void DateTimeToString(char * buf, int Date, unsigned long Time, bool dst) {
	word da, mo, ye, ho, mi, se;
	char IsDst = 0x20; // space
		
	if (dst)
		IsDst = 0x2A; // asterisk
			
	DecodeDate(&da, &mo, &ye, Date);
	DecodeTime(Time, &ho, &mi, &se, dst);
	sprintf(buf, "%2.2d/%2.2d/%2.2d %c%2.2d:%2.2d:%2.2d", da, mo, ye, IsDst, ho, mi, se);
}

// monday = 0, sunday = 6
// 01/01/2000 = saturday = 5
byte DayOfWeek(word dt) {
  word dow;

  dow = ((dt + 5) % 7);
  return dow;
}


// modfied 28/10/2021 version 3.09
word GetDSTDate(word month, word year, bool show) {
  word dt, d, m, y;
  char buf[12];

  dt = EncodeDate(31, month, year);

// make the last sunday in the month
  dt = dt - ((dt - 1) % 7);
  DateToString(buf, dt);
  if (show)
    Serial.printf("--> DST Threshold %s\r\n", buf);

  return dt;
}

bool IsDSTActive(word dt, long tm, bool	DSTinUse, bool show) {
  word dy, mn, yr, hr, mi, se, DstS, DstE;
  bool IsDst;

  IsDst = false;

  if (DSTinUse) {
    DecodeDate(&dy, &mn, &yr, dt);
    DecodeTime(tm, &hr, &mi, &se, IsDst);

    DstS = GetDSTDate(3, yr, show);
    DstE = GetDSTDate(10, yr, show);

    if (((dt == DstS) & (hr >= 2)) || ((dt == DstE) & (hr < 2))) {
      IsDst = true;
	  } else {
      IsDst = (dt > DstS) and (dt < DstE);
	  }
  } else {
    IsDst = DSTinUse;
  }	

  return IsDst;
}

bool IsDSTActive1(word dt, long tm, bool DSTinUse, bool show) {
  word dy, mn, yr, hr, mi, se, DstS, DstE;
  bool IsDst;

  if (DSTinUse) {
    DecodeDate(&dy, &mn, &yr, dt);
    DecodeTime(tm, &hr, &mi, &se, IsDst);

    DstS = GetDSTDate(3, yr, show);
    DstE = GetDSTDate(10, yr, show);

    if (((dt == DstS) & (hr >= 2)) || ((dt == DstE) & (hr < 2))) {
      IsDst = true;
	} else {
      IsDst = (dt > DstS) and (dt < DstE);
	}
  } else {
    IsDst = DSTinUse;
  }	
  
  return IsDst;
}

// --------------------------

// Returns 0 for failure, 1 for WT success and 2 for NTP success
// Tries WT first, NTP second
uint8_t getNetworkTime(char * srv, tm * dt, uint8_t Tries) {
  if (getWorldTime(srv, dt, Tries))
    return 1;
  else 
    if (getLocalTime(dt))
      return 2;
    else
      return 0;
}

/*  In the case of a failed getWTDateTime()
    call repeat it up to MAX_TRIES times. */
bool getWorldTime(char * srv, tm * dt, uint8_t Tries) {
  uint8_t triesLeft = Tries;
  bool ok = false;

  do {
      ok = getWTDateTime(srv, dt);
      triesLeft--;
  }
  while ((triesLeft > 0) && !ok);

  return ok;
}

/*  Does a one time check on World Time.  If it fails
    then it exits with a false. Failure is usually
    because of a very slow respons from the server 
    or sometimes none at all.
    WARNNING - Too many uses in a short period will
    result in a "Too Many Requests" error. */

bool getWTDateTime(char * server, tm * ddt) 
{
  HTTPClient http;
  bool ok = false;
  
  http.setConnectTimeout(10000);
  http.setTimeout(10000);

  // get date/time based from "server"
  http.begin(server); 

  int httpResponseCode = http.GET();

  if (httpResponseCode > 0) {
    String payload = http.getString();

//  check for failure
    if ((payload.length() == 0) || (strncmp("Too Many Requests", payload.c_str(), 17) == 0)) {
      http.end();
      return false;
    }
           
    JsonDocument doc;

    DeserializationError error = deserializeJson(doc, payload.c_str());
    if (error) {
      ok = false;
      http.end();
      return false;
    } else {
      ok = true;

//    get date and time
      const char * localdatetime = doc["datetime"].as<const char *>();

//    This what the datetime field looks like
//    01234567890123456789012345678901
//    2023-09-17T02:50:07.972160-04:00

      uint8_t Idx = 0;

// extract the date/time info from the local date time string
      while(ok && Idx < 19) {
        switch(Idx) {
//        ---- YEAR ----
          case 2:   ddt->tm_year = (localdatetime[Idx] - 0x30) * 10;
                    break;
          case 3:   ddt->tm_year += (localdatetime[Idx] - 0x30);
                    break;
//        ---- MONTH ----
          case 5:   ddt->tm_mon = (localdatetime[Idx] - 0x30) * 10;
                    break;
          case 6:   ddt->tm_mon += (localdatetime[Idx] - 0x30);
                    break;
//        ---- DAY ----
          case 8:   ddt->tm_mday = (localdatetime[Idx] - 0x30) * 10;
                    break;
          case 9:   ddt->tm_mday += (localdatetime[Idx] - 0x30);
                    break;
//        ---- HOUR ----
          case 11:  ddt->tm_hour = (localdatetime[Idx] - 0x30) * 10;
                    break;
          case 12:  ddt->tm_hour += (localdatetime[Idx] - 0x30);
                    break;
//        ---- MIN ----
          case 14:  ddt->tm_min = (localdatetime[Idx] - 0x30) * 10;
                    break;
          case 15:  ddt->tm_min += (localdatetime[Idx] - 0x30);
                    break;
//        ---- SEC ----
          case 17:  ddt->tm_sec = (localdatetime[Idx] - 0x30) * 10;
                    break;
          case 18:  ddt->tm_sec += (localdatetime[Idx] - 0x30);
                    break;
        }
        Idx++;
      }

//    tm_mon in the tm structure is 0-11 not 1-12
      if (ok) {
        ddt->tm_mon--;
        ddt->tm_isdst = doc["dst"].as<bool>();
        ddt->tm_wday = doc["day_of_week"].as<int8_t>();
        ddt->tm_yday = doc["day_of_year"].as<int16_t>();
      }
    }
  }

  http.end();

  return ok;
}

/*  Get the date and time and transfer to the dateInfo structure.
    DateInfo is defined in Common/CommonDefs.h.
    The time returned by getLocalTime is already corrected
    for DST if it is summer time. The server parameter is
    for the WT server 
    "http://worldtimeapi.org/api/timezone/Europe/London\0" */

bool getSystemDateTime(volatile DateInfo * di, char * server, char * msg) {
  tm timeinfo;
  bool ok = false;
  char src[10];
  char printbuf[255];
  uint8_t timeSrc = 0;
  uint32_t oldTime = di->CurTime;
  uint32_t start = millis();

  timeSrc = getNetworkTime(server, &timeinfo, MAX_NET_TRIES);
    switch (timeSrc) {
    case 0: strcpy(src, "FAILED");
            break;
    case 1: strcpy(src, "WTA");
            break;
    case 2: strcpy(src, "NTP");
  }

  if (timeSrc > 0) {
    ok = true;
    di->CurDate         = EncodeDate(timeinfo.tm_mday, timeinfo.tm_mon + 1, timeinfo.tm_year % 100);
    di->CurTime         = EncodeTime(timeinfo.tm_hour, timeinfo.tm_min, timeinfo.tm_sec);
    di->isSummer        = timeinfo.tm_isdst;
    di->SecondsElapsed  = di->CurTime % 60;

    sprintf(printbuf, "Time synchronisation via %s in %d mS - Old: %d New: %d Diff: %d",
                              src,
                              millis() - start, 
                              oldTime,
                              di->CurTime, 
                              di->CurTime - oldTime
                            );
                            
    strcpy(msg, printbuf);
  } else
    strcpy(msg, "getSystemDateTime() unable to get local time!");

  return ok;
}

int32_t getWTTime(char * server) {
  HTTPClient http;
  bool ok = false;
  tm ddt;

  http.begin(server); // get date/time based on IP
  int httpResponseCode = http.GET();

  if (httpResponseCode > 0) {
    String payload = http.getString();
     
    JsonDocument doc;

    DeserializationError error = deserializeJson(doc, payload.c_str());
    if (error) {
      Serial.print("deserializeJson() failed: ");
      Serial.println(error.f_str());
      http.end();
      return -1;
    } else {
      const char * localdatetime = doc["datetime"].as<const char *>();

//    01234567890123456789012345678901
//    2023-09-17T02:50:07.972160-04:00

      uint8_t Idx = 11;

// extract the date/time info from the local date time string
      while(Idx < 19) {
        switch(Idx) {
//        ---- HOUR ----
          case 11:  ddt.tm_hour = (localdatetime[Idx] - 0x30) * 10;
                    break;
          case 12:  ddt.tm_hour += (localdatetime[Idx] - 0x30);
                    break;
//        ---- MIN ----
          case 14:  ddt.tm_min = (localdatetime[Idx] - 0x30) * 10;
                    break;
          case 15:  ddt.tm_min += (localdatetime[Idx] - 0x30);
                    break;
//        ---- SEC ----
          case 17:  ddt.tm_sec = (localdatetime[Idx] - 0x30) * 10;
                    break;
          case 18:  ddt.tm_sec += (localdatetime[Idx] - 0x30);
                    break;
        }
        Idx++;
      }
      return (ddt.tm_hour * 3600) + (ddt.tm_min * 60) + ddt.tm_sec;
    }
  }
  return -1;
}

/* 
  Start the NTP time service and collect the first time value.
  The default update period of 15s is used.
*/
uint64_t Init_ESP_SNTP(char * Server, int32_t Offset_From_UTC, int32_t DST_Offset, bool useDST) {

  uint32_t Secs = 0, uSecs = 0;
  
  _Offset_From_UTC  = Offset_From_UTC;
  _DST_Offset       = DST_Offset;
  _Use_DST          = useDST;

//  sntp_setservername(0, "pool.ntp.org");
  sntp_setservername(0, Server);
  sntp_set_sync_mode(SNTP_SYNC_MODE_IMMED);
  sntp_setoperatingmode(SNTP_OPMODE_POLL);
  sntp_set_sync_interval(60000);
  sntp_init();
  sntp_get_system_time(&Secs, &uSecs);
  return Secs + _Offset_From_UTC;
}

/* 
  Puts current date and time into a tm structure
  tm_wday is set to current time, seconds since midnight
  tm_yday is set to days since 01/01/2000
*/
ntpTime Get_ESP_NTP_Time(tm * timeinfo) {
  uint32_t Secs, uSecs;
  word d, m, y;
  bool isdst;

// clear timeinfo
  memset(timeinfo, 0, sizeof(tm));

// returns seconds since 01/01/1970 as UTC (GMT0)
  ntpTime nt;
  sntp_get_system_time(&Secs, &uSecs);
  nt.Sv = Secs;
  nt.uSv = uSecs;

  if (Secs > 0) {
    Secs = Secs + _Offset_From_UTC;

    uint32_t ct = Secs % 86400; // time, secs since midnight
    uint16_t dt = (Secs / 86400) - 10957; // date since 2000

    if (Secs > 1000000) {
      isdst = IsDSTActive(dt, ct, _Use_DST, false);

      if (isdst) {
        if (ct >= 82800) { // >= 23:00
          ct = ((ct + _Offset_From_UTC) % 86400);
          dt++;
        } else
          ct += _DST_Offset;
      }
  
      DecodeDate(&d, &m, &y, dt);
  
      timeinfo->tm_hour = ct / 3600;
      timeinfo->tm_min  = (ct - (timeinfo->tm_hour * 3600)) / 60;
      timeinfo->tm_sec  = ct % 60;
      timeinfo->tm_mday = d;
      timeinfo->tm_mon  = m;
      timeinfo->tm_year = y;
      timeinfo->tm_wday = ct;
      timeinfo->tm_yday = dt;
      timeinfo->tm_isdst  = isdst;
      }
  }
  return nt;
}

ntpTime Get_ESP_NTP_Time(tm * timeinfo, int32_t dst_offset) {
  uint32_t Secs, uSecs;
  word d, m, y;
  bool isdst;

// clear timeinfo
  memset(timeinfo, 0, sizeof(tm));

// returns seconds since 01/01/1970 as UTC (GMT0)
  ntpTime nt;
  sntp_get_system_time(&Secs, &uSecs);
  nt.Sv = Secs;
  nt.uSv = uSecs;

  if (Secs > 0) {
    Secs = Secs + dst_offset;

    uint32_t ct = Secs % 86400; // time, secs since midnight
    uint16_t dt = (Secs / 86400) - 10957; // date since 2000

    if (Secs > 1000000) {
      isdst = IsDSTActive(dt, ct, _Use_DST, false);

      if (isdst) {
        if (ct >= 82800) { // >= 23:00
          ct = ((ct + _Offset_From_UTC) % 86400);
          dt++;
        } else
          ct += _DST_Offset;
      }
  
      DecodeDate(&d, &m, &y, dt);
  
      timeinfo->tm_hour = ct / 3600;
      timeinfo->tm_min  = (ct - (timeinfo->tm_hour * 3600)) / 60;
      timeinfo->tm_sec  = ct % 60;
      timeinfo->tm_mday = d;
      timeinfo->tm_mon  = m;
      timeinfo->tm_year = y;
      timeinfo->tm_wday = ct;
      timeinfo->tm_yday = dt;
      timeinfo->tm_isdst  = isdst;
      }
  }
  return nt;
}

int32_t GetNTPTime(char * Server) {
  
  tm timeinfo;

  configTime(0, 0, Server);
  
  bool ok = false; 
  uint8_t tries = 3;

  do {
    ok = getLocalTime(&timeinfo);

    if (!ok) {
      delay(250);
      tries--;
    }
  } while ((ok = false) && (tries > 0));

  if (tries == 0)
    return -1;

  return (timeinfo.tm_hour * 3600) + (timeinfo.tm_min * 60) + timeinfo.tm_sec;

}
