/*
   Last Modified Time: March 10, 2026 at 11:47:33 AM
*/

#ifndef LOGGER_H
#define LOGGER_H

void timePrint(const char * msg, uint16_t date, uint32_t time);
bool NeedToFlushLog();
char* GetLog();
void ClearLog();
uint16_t GetLogSize();
void TouV(int16_t value, char * Buffer);
char* GetBootReason(uint8_t brc);


#endif