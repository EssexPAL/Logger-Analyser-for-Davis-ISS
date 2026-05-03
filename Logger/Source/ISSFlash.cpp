/*
   Last Modified Time: April 24, 2026 at 6:38:03 AM
*/

#include <Arduino.h>
#include <Arduino.h>
#include <EEPROM.h>
#include "ISSFLASH.h"
#include "Defs.h"
#include "Logger.h"

char itoh(byte val, bool wantHigh) {
  if (wantHigh) {
    val >>= 4;
  }
  
  val &= 0x0F;

  if (val > 9) {
    return val + 55;
  } else {
    return val + 48;
  }
}

void HexDump(const char* text, byte* inbuf, int Count) {
  char hexbuf[64];
  char chrbuf[20];
  int Cnt = 0;
  int hp = 0;
  int cp = 0;
  
//  Serial.println("");
  Serial.printf("** %s ** Bytes: %d\r\n", text, Count);
  do {  
    if ((*inbuf >=0x20) && (*inbuf < 0x80)) {
      chrbuf[cp++] = *inbuf;
    } else {
      chrbuf[cp++] = '.';
    }
    chrbuf[cp] = 0;

    hexbuf[hp++] = itoh(*(inbuf), true);
    hexbuf[hp++] = itoh(*(inbuf++), false);
    hexbuf[hp++] = ' ';
    hexbuf[hp] = 0;

    if (((Cnt & 15) == 15) || (Cnt == Count - 1)) {
      Serial.printf("%4X (%4d): %s %s\r\n", Cnt & 0XFFF0, Cnt & 0XFFF0, hexbuf, chrbuf);
      hexbuf[0] = 0;
      chrbuf[0] = 0;
      hp = 0;
      cp = 0;
    }
    Cnt++;
  } while (Cnt < Count);
//  Serial.println("");
}

void DumpFlashData(const char * Text) {
    TFlashData fD;

  EEPROM.begin(DATASIZE);
  EEPROM.get(0, fD);
  EEPROM.end();

  HexDump(Text, (byte *) &fD, DATASIZE);

}

// write data to flash
void WriteFlashData(TFlashData *Fd, TSSIDLIST *Sd, bool Init) {
  
    
  if (!Init) {
    byte buf[DATASIZE];

//  add data to buffer
    memcpy(buf, Fd, DATASIZE - SSIDSIZE);
    memcpy(buf + (DATASIZE - SSIDSIZE), Sd, SSIDSIZE);

    EEPROM.begin(DATASIZE);
    EEPROM.put(0, buf); // all data
    EEPROM.commit();
    EEPROM.end();
    Serial.println("FLASH data written\r\n");
  } else { // flash not initialised! 
    EEPROM.end();
    InitFlash();
  }
}

void InitFlash() {
  int Offset = sizeof(FLASHHEADER);
  TFlashData Fd;
  char buf[40];
  char * p;
  
  memset(&Fd, 0, DATASIZE);
  EEPROM.begin(DATASIZE);

// ---- SYSTEM DATA ----
// default for system data
  strcpy(Fd.Header, FLASHHEADER);
  strcpy(Fd.hostName, DEFAULT_HOSTNAME);
  Fd.UseDST = true;
  Fd.UTC_Offset = 0;
  Fd.DST_Offset = 0;

  p = (char *) &Fd.ssid;

  strcpy(p, "SSID");
  p += SSIDNAMESIZE;
    
  strcpy(p, "KEY");
  p += SSIDKEYSIZE;

  strcpy(p, "pool.ntp.org");
  p += SSIDNAMESIZE;
  
  EEPROM.put(0, Fd); // system data  
  EEPROM.commit();
  EEPROM.end();
}

bool ReadFlashData(TFlashData * fD, TSSIDLIST * sL) {
  
byte buf[DATASIZE];
bool ok =

//  Serial.printf("\r\n DATA SIZE %d %x", DATASIZE, DATASIZE);

  EEPROM.begin(DATASIZE);
  EEPROM.get(0, buf);
  EEPROM.end();

  if (strncmp((char*) buf, FLASHHEADER, sizeof(FLASHHEADER)) == 0) {
    ok = true;
  } else {

  // flash not initizlised so fill it with defaults
    InitFlash();

  //  re-get the flash
    EEPROM.begin(DATASIZE);
    EEPROM.get(0, buf);
    EEPROM.end();
  }

  memcpy(fD, buf, DATASIZE);
  memcpy(sL, buf + (DATASIZE - SSIDSIZE), SSIDSIZE);

  return ok;
}

