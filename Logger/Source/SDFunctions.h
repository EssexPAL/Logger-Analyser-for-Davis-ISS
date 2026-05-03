/*
   Last Modified Time: April 24, 2026 at 6:40:06 AM
*/

#ifndef SDFUNCTIONS_H
#define SDFUNCTIONS_H

#include <Arduino.h>
#include <SdFAT.h>
#include <ArduinoJson.h>
#include <AsyncUDP.h>
#include <WiFi.h>
#include <sdios.h>
#include "ATDateandTime.h"
#include "CommonDefs.h"


#define QDATASIZE 100
#define UDPPORT 2010

enum tLoggerCmd { 
                  lcNone = 0,
                  lcAck = 1,  
                  lcLiveData = 2, 
                  lcLoggerStatus = 3, 
                  lcGetDirectory = 4, 
                  lcGetFile = 5, 
                  lcEraseFile = 6, 
                  lcEraseAll = 7, 
                  lcRestart = 8,
                  lcAppendData = 9,
                  lcAppendLog = 10,
                  lcGetLog = 11,
                  lcAppendLogBuffer = 12
                };


struct SDcmd {
  bool          active;
  IPAddress     IP;
  uint16_t      port;
  tLoggerCmd    cmd;
  uint8_t       clientIndex;
  bool          ready;
  bool          newfile;
  u_int16_t     atdate;
  char          filename[32];
  char          directory[32];          
  char          data[QDATASIZE]; // one data line is 42
};

struct RemoteRequest
{
    tLoggerCmd  Request;
    IPAddress   IP;
    char        FileName[32];
    char        Data[QDATASIZE];
    uint16_t    date;
};

const uint16_t D_BLOCKBUFFERSIZE = 1024;
const uint16_t F_BLOCKBUFFERSIZE = 768;
const uint16_t E_BUFFERSIZE = 60;

void sdActions(SDcmd* sdci);
int16_t CountFiles(SDcmd* sdci);
bool sd_LoadFile(SDcmd* sdci);
bool sd_SendDirectory(SDcmd* sdci);
void SendUDPMessage(IPAddress host, uint16_t port, char * msg);
void SendUDPBlock(IPAddress host, uint16_t port,  tLoggerCmd msgno, uint16_t blockNo, uint16_t blockCount, bool isLast, uint16_t TotalBlocks, char * msg);
void GetStatus(SDcmd* sdci);
bool sd_AppendDataToFile(SDcmd* sdci);
//void AddLocalRequestToQueue(tLoggerCmd cmd);
void AddLocalRequestToQueue(SDcmd sdci);

void GetDiskInfo(DiskInfo * di);
void AppendLogBuffer();
void getDiskStats(bool active);
void AddSizeSuffix(char* outbuf, uint32_t value);



// -------------------------------------------------------------

#define QUEUESIZE 8

class CmdQueue {
    public:

        CmdQueue() { // consructor
            flush();
        };

    /*  
    * Pushes the supplied item into the queue.
    */
        bool push(RemoteRequest a) {
            bool ok = false;

            if (count < QUEUESIZE) {
                queue[inIdx] = a;
                count++;
                inIdx++;
                inIdx &= 0x07;
                ok = true;
            }
            return ok;
      };

    /*  
    * Returns the next item in the queue.
    */
        RemoteRequest pop() {
            bool ok = false;
            RemoteRequest remr;

            if (count > 0) {
                count--;
                remr = queue[outIdx];
                outIdx++;
                outIdx &= 0x07;
            }

            return remr;
        };

    /*  
    * Clear all entries in the queue, its count and its index's.
    */
        void flush() {
            inIdx = 0;
            outIdx = 0;
            count = 0;
            memset(queue, 0, sizeof(queue));
        };
        
    /*  
    * Returns the input index.
    */
        uint8_t getInIdx() {
            return inIdx;
        };

    /*  
    * Returns the ouyput index.
    */
        uint8_t getOutIdx() {
            return outIdx;
        };

    /*  
    * Returns the number of items in the queue.
    */
        uint8_t getCount() {
            return count;
        };

    private:
        RemoteRequest queue[QUEUESIZE];
        uint8_t inIdx;
        uint8_t outIdx;
        uint8_t count;
};


#endif // SDFUNCTIONS_H
