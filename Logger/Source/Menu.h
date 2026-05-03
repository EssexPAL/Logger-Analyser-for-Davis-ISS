/*
   Last Modified Time: April 23, 2026 at 6:45:44 AM
*/

#ifndef MENU_h
#define MENU_h

#include "ISSFlash.h"
#include "ATDateandTime.h"
#include "Defs.h"
#include <WiFi.h>
#include "CommonDefs.h"
#include "Logger.h"
#include "DavisISSLib.h"

#define SERIALBUFFERSIZE 64

void serialEvent();
void ShowMenu();
void MakeSpace(byte Lines);
void trimRhWhiteSpace(char* buf, int8_t len);
void clearSerialBuffer(void);
void DumpSystemData(TFlashData Fd, RFMPacketStats ps, boolean showtime);
//void DumpSystemData(TFlashData Fd, TSSIDLIST Sd, PacketStats ps, boolean showtime);


#endif // MENU_H

