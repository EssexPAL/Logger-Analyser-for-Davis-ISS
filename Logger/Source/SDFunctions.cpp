/*
   Last Modified Time: April 25, 2026 at 5:52:46 AM
*/

/*  
    * This module contains all the code that 
    * runs in core 0.  This is everything
    * that envolves SD and data for the 
    * client.
*/

/* 
    SD defaults when using HSPI
    Strapping pins
    GPIO 5: Defaults to pull-up; affects SDIO slave timing.
    GPIO 12 (MTDI): Defaults to pull-down; if pulled HIGH at boot, the internal flash voltage 
                    (VDD_SDIO) drops, causing the chip to fail to boot.
    GPIO 15 (MTDO): Defaults to pull-up; affects debugging output (LOW hides boot messages). 
    SPI pins
    VSPI GPIO 23 (MOSI), GPIO 19 (MISO), GPIO 18 (SCK), --> GPIO  5 (CS/SS) <--. 
    HSPI GPIO 13 (MOSI), --> GPIO 12 (MISO) <--, GPIO 14 (SCK), --> GPIO 15 (CS) <--.
*/

#include "SDFunctions.h"
#include "Logger.h"
#include "CommonDefs.h"
#include "Defs.h"
#include "DavisRFM69.h"
#include "flashLED.h"



extern SdFs sd;
extern AsyncUDP  udp;
extern LiveData liveData;
extern DateInfo dateInfo;
extern DavisRFM69 radio;
extern DiskInfo diskInfo;
extern RFMPacketStats packetStats;
extern WsData wsData;
extern DiskInfo diskinfo;
extern CmdQueue cQueue;
extern flashLED grnLED;
extern flashLED redLED;

extern void AppendLog(const char* message);

bool sd_EraseFile(SDcmd* sdci);
void SendAck(IPAddress host, uint16_t port, uint32_t size, tLoggerCmd msgno, boolean ack);
void GetLiveData(SDcmd* sdci);
bool sd_DeleteDataFiles(SDcmd* sdci);
int16_t CountFiles(SDcmd* sdci);
bool sd_AppendDataToFile(SDcmd* sdci);

const char * actionText[] = { "",               "",             "Live Data",  "Get Status", 
                              "Get Directory",  "Get File",     "Erase File", "Erase All", 
                              "Restart",        "Append Data",  "Append Log",  "Get Log",   "Append Log Buffer" };

void sdActions(SDcmd* sdci) {

  FsFile curFile;
  char buf[100];
  uint32_t t = millis();

  switch (sdci->cmd) {
      case  lcLiveData: {
              GetLiveData(sdci);
              break;
            }
      case  lcLoggerStatus: {
              GetStatus(sdci);
              redLED.pulse(1);
              break;
            }
      case  lcGetDirectory: {
              sd_SendDirectory(sdci);
              redLED.pulse(1);
              break;
            }
      case  lcGetFile: {
              sd_LoadFile(sdci); 
              redLED.pulse(1);
              break;
            }
      case  lcEraseFile: {
              sd_EraseFile(sdci);
              snprintf(buf, sizeof(buf), "File %s deleted on %d %d", sdci->filename, dateInfo.CurDate, dateInfo.CurTime);
              AppendLog(buf);
              redLED.pulse(1);
              break;
            }
      case  lcEraseAll: { // erase all data files
              sd_DeleteDataFiles(sdci);
              redLED.pulse(1);
              break;
            }
      case  lcRestart: {
      // need to flush outstanding data before reboot
              AppendLog("Remote restart requested");
              redLED.pulse(1);

              Serial.println("Restart");
              ESP.restart();
              break;
            }
      case  lcAppendData: {
              sd_AppendDataToFile(sdci);
              redLED.pulse(1);
              break;
            }
      case  lcAppendLog: {
              sd_AppendDataToFile(sdci);
              redLED.pulse(1);
              break;
            }
      case  lcGetLog: {
              // override path and file info in sdci
              strncpy(sdci->directory, "/", 32);
              strncpy(sdci->filename, SYSLOGFILE, 32);
              sd_LoadFile(sdci);
              redLED.pulse(1);
            }
      case  lcAppendLogBuffer: {
              strncpy(sdci->directory, "/", 32);
              strncpy(sdci->filename, SYSLOGFILE, 32);
              sd_AppendDataToFile(sdci);
              redLED.pulse(1);
              break;
            }
          
    }
    Serial.printf("Actions(%-17s) %2d mS\n", (const char *) actionText[sdci->cmd], millis() - t);
}

// This is crude brute force 
void AddSizeSuffix(char* outbuf, uint32_t value) {

  double val = value;
  uint8_t sub = 0;

  if (val >= 1000000000) {
    val /= 1000000000;
    sub = 1;
  } else if((val >= 1000000) && (val < 1000000000)) {
    val /= 1000000;
    sub = 2;
  } else if ((val >= 1000) && (val < 1000000)) {
    val /= 1000;
    sub = 3;
  }
  else {
    sub = 4;
  }

  outbuf[0] = 0;
  sprintf(outbuf, "%f", val);

  char* dotpos = strchr(outbuf, '.');
  size_t clen = (dotpos - outbuf);

  if (dotpos != NULL) {
    if (sub == 4)
      outbuf[clen] = 0;
    else
    outbuf[clen + 3] = 0;
    
  switch (sub) {
    case 4: strcat(outbuf, " B");
            break;
    case 3: strcat(outbuf, " KB");
            break;
    case 2: strcat(outbuf, " MB");
            break;
    case 1: strcat(outbuf, " GB");
            break;
    }
  }

}

void getDiskStats(bool active) {
  
    uint32_t bpc = sd.vol()->bytesPerCluster();
    uint64_t tcc = sd.vol()->clusterCount();
    uint32_t fcc = sd.vol()->freeClusterCount();

    diskInfo.SpaceLeft = (uint64_t) fcc * bpc;
    diskInfo.SpaceUsed = (uint64_t) (tcc - fcc) * bpc;

    SDcmd sdci;
    sdci.active = active;
    strcpy(sdci.directory, "/Data");

    diskInfo.FileCount = CountFiles(&sdci);  

}

// Add a request to the queue that does not
// original from the remote user 
void AddLocalRequestToQueue(SDcmd sdci) {
  RemoteRequest rr;

  rr.Request = sdci.cmd;
  strncpy(rr.FileName, sdci.filename, 32);
  strncpy(rr.Data, sdci.data, 100);
  rr.IP.fromString("0");
  rr.date = sdci.atdate;
  cQueue.push(rr);
}


/* 
 * SdFat - Gets the directory for the specified folder.
 * The directory is sent in n 1024 byte blocks with
 * no padding of fields. 
 */

bool sd_SendDirectory(SDcmd* sdci) {
  
  char fn[32];
  char RowBuffer[E_BUFFERSIZE];
  char BlockBuffer[D_BLOCKBUFFERSIZE];
  bool ok = false;
  uint16_t blockNo = 1;
  uint16_t bytesleft;
  uint16_t rowcount = 0;
  uint16_t blockCount = 1;
  bool     eod = false;

  if (sdci->active) {
    FsFile base = sd.open(sdci->directory, O_RDONLY);
      
    blockNo = 1;
    bytesleft = D_BLOCKBUFFERSIZE;
    memset(BlockBuffer, 0, D_BLOCKBUFFERSIZE);
    
//  loop through the file enties
    while (true) {
      FsFile entry = base.openNextFile();
      if (!entry) {
        eod = true;
        break;
      }

//    make directory line
      if (entry.isFile()) {
        uint16_t size = entry.getName(fn, 32);
        uint32_t fsize = entry.fileSize();
        snprintf(RowBuffer, E_BUFFERSIZE, "%s:%d\r\n", fn, fsize);
        rowcount++;
      }
      entry.close();


//    add line to the block buffer
      if (bytesleft >= strlen(RowBuffer)) {
      // buffer has space
        strncat(BlockBuffer, RowBuffer, D_BLOCKBUFFERSIZE - 1);
        bytesleft -= strlen(RowBuffer);
      } else {
//      buffer is full
// --------------------------------------
          SendUDPBlock( sdci->IP, 
                        sdci->port, 
                        sdci->cmd, 
                        blockNo, 
                        strlen(BlockBuffer), 
                        eod, 
                        blockCount, 
                        BlockBuffer);
 
          blockNo++;
          blockCount++;
          bytesleft = D_BLOCKBUFFERSIZE;
//        clear the block buffer and add the entry to it
          memset(BlockBuffer, 0, D_BLOCKBUFFERSIZE);
          strncat(BlockBuffer, RowBuffer, D_BLOCKBUFFERSIZE - 1);
          bytesleft -= strlen(RowBuffer);
// --------------------------------------
      }
    }
  
// save any data still in the buffer
    if (bytesleft < D_BLOCKBUFFERSIZE) 
// --------------------------------------
      SendUDPBlock( sdci->IP, 
                    sdci->port,   
                    sdci->cmd, 
                    blockNo, 
                    strlen(BlockBuffer), 
                    eod, 
                    blockCount, 
                    BlockBuffer); 
// --------------------------------------
    
    base.close();
    ok = true;

  } else {
    ok = false;
  } 

  return ok;
}

/*  sd_EraseFile()
    Loaded into core 0.
    Deletes the file from the specified directory.
    The sdci structure provides the file name and directory. 
*/

bool sd_EraseFile(SDcmd* sdci) {
    bool ok = false;
    bool needcreate = true;
    FsFile curFile;

    if (sd.chdir("/Data")) {
      // need to create ?
      if (sd.exists(sdci->filename)) {
        ok = sd.remove(sdci->filename);
      } else {
        Serial.printf("No File: Dir: <%s> Fn: <%s>\n", sdci->directory, sdci->filename);
      }
    }
            
    SendAck(sdci->IP, sdci->port, 1, lcAck, ok); 
    return ok; 
}

/*  
    sd_AppendDataToFile()
    Loaded into core 0.
    Opens the file from the specified directory.
    If the file does not exist then it will be created.
    The sdci structure provides the file name and directory. 
*/

bool sd_AppendDataToFile(SDcmd* sdci) {

    bool ok = false;
    bool needcreate = true;
    FsFile curFile;

    if (sd.chdir(sdci->directory)) {
      needcreate = !sd.exists(sdci->filename); // need to create ?
      if(curFile = sd.open(sdci->filename, O_WRONLY | O_CREAT | O_AT_END)) {
        switch(sdci->cmd) {
        case lcAppendData:
                        if (needcreate) // add header on a new file
                          curFile.printf("#%04.4d\r\n", sdci->atdate);
                        // add data
                        curFile.println(sdci->data);
                        break;
        case lcAppendLog:  // if file is larger than 1MB then truncate and add header
                        if (curFile.fileSize() > LOG_MAX_SIZE) {
                          curFile.seek(0);
                          curFile.truncate();
                          curFile.printf("Log created on %d\r\n", sdci->atdate);
                        }
                      // add data
                        curFile.println(sdci->data);
                        break;
        case lcAppendLogBuffer:
                      if (curFile.fileSize() > LOG_MAX_SIZE) {
                        curFile.seek(0);
                        curFile.truncate();
                        curFile.printf("Log created on %d\r\n", sdci->atdate);
                      }
                      // add data
                      if (GetLogSize() > 0) {
                        uint16_t printed = curFile.print(GetLog());
                        ClearLog();
                      }
                      break;             
          }
          
          curFile.flush();
          curFile.close();
          ok = true;
        } else {
          Serial.printf("Unable to open/create %s\n", sdci->filename);
          ok = false;
        }
      } else {
        Serial.printf("Unable to goto directory %s\n", sdci->directory);
        ok = false;
      }
    return ok; 
}

/*  sd_LoadFile()
    Loaded into core 0.
    Load the file from the specified directory.  The sdci
    structure provides the file name and directory. 
    The calling routine is running in core 1 and will deallocate the buffer.
    The function sends data in n BLOCKSIZE blocks. 
*/

bool sd_LoadFile(SDcmd* sdci) {
#define ALLOWANCE 20

    bool ok = false;
    FsFile curFile;
    char buffer[F_BLOCKBUFFERSIZE + ALLOWANCE];
    uint32_t fileSize;
    uint16_t bytesRead, bytesLeft, blockNo, blockCount;

    if(sd.chdir(sdci->directory)) {
      if (curFile = sd.open(sdci->filename, O_RDONLY)) {
                    
          // init variables
        fileSize = curFile.fileSize();
        blockCount = (fileSize / F_BLOCKBUFFERSIZE) + 1;
        blockNo = 1;
        bytesLeft = fileSize;
    
        // read data in blocks and send
        while (bytesLeft > 0) {
          // Clear buffer before use
          memset(buffer, 0, F_BLOCKBUFFERSIZE + ALLOWANCE);
          bytesRead = curFile.readBytes(buffer, F_BLOCKBUFFERSIZE);

          SendUDPBlock( sdci->IP, 
                        UDPPORT, 
                        sdci->cmd, 
                        blockNo, 
                        bytesRead,
                        (bool) (blockNo == blockCount),
                        blockCount,
                        buffer);

            bytesLeft -= bytesRead;
            blockNo++;
        }
            // close the file
        curFile.close();
        ok = true;

        // mark the data as ready and clear the command
        sdci->cmd = lcNone;
      } else
        Serial.printf("--> Unable to open (%s) %s\n", sdci->directory, sdci->filename);
    }
    
    return ok;
}

/* Returns the number of files in the specified folder
 * or -1 if the folder does not exist. */

int16_t CountFiles(SDcmd* sdci) {

  int16_t count = 0;
  int16_t result = -1;
  
  if (sdci->active) {
    if (FsFile root = sd.open(sdci->directory, O_RDONLY)) {
      // loop through the files in the folder excluding directories
      do {
        FsFile entry = root.openNextFile();
        if (!entry) {
          result = count;
          break;
        }
        // exclude
        if (!entry.isDirectory()) {
          count++;
        }
        entry.close();
      } while (true);
      root.close();
    }
  }
  return count;
}

void SendUDPBlock(IPAddress host, uint16_t port,  tLoggerCmd msgno, uint16_t blockNo, uint16_t blockCount, bool isLast, uint16_t TotalBlocks, char * msg) {
  
  JsonDocument doc;
  
  char buf[1200]; // 837  for files, actually 872
                  // 1093 for directories, actually 1146
  
  doc["mi"] = msgno;        // message id 
  doc["bc"] = blockCount;   // bytes in block, up to BLOCKBUFFERSIZE
  doc["bn"] = blockNo;      // block no
  doc["nb"] = TotalBlocks;  // Total blocks
  doc["lb"] = isLast;
  doc["bd"] = msg;
  serializeJson(doc, buf);

  SendUDPMessage(host, port, buf);
}

void CheckJson(char* buf) {
  uint8_t open = 0, close = 0;

  for (uint16_t Idx = 0; Idx < strlen(buf); Idx++) {
    switch (buf[Idx]) {
      case '{': {
                  open++;
                  break;
      }
      case '}': {
                  close++;
                  break;
      }
    }
  }
  Serial.printf("Opening %d Closing %d\n", open, close);
}

void SendAck(IPAddress host, uint16_t port, uint32_t size, tLoggerCmd msgno, boolean ack) {
  
  JsonDocument doc;
  char buf[40]; // 35 bytes needed
  
  doc["mi"] = msgno;        // message id 
  doc["sz"] = size;
  doc["ack"] = ack;         // bytes in block, up to BLOCKBUFFERSIZE
  serializeJson(doc, buf);
  SendUDPMessage(host, port, buf);

}

void SendUDPMessage(IPAddress host, uint16_t port, char * msg) {

  if (udp.connect(host, port)) {
    strcat(msg, "\n");
    udp.print(msg);
    udp.close();

  } else
    Serial.printf("Unable to open connection: Host: %s Port: %d\n", host.toString(), port);
}

void GetLiveData(SDcmd* sdci) {
   
//  DynamicJsonDocument doc(192);
  JsonDocument doc;
  char buffer[125]; // 115 bytes needed, actually 93

  doc["mi"] = sdci->cmd;
  doc["ip"] = (uint32_t) sdci->IP;
  doc["ct"] = dateInfo.CurTime;
  doc["wd"] = liveData.WindDir;
  doc["ws"] = liveData.WindSpeed;
  doc["tm"] = liveData.Temperature;
  doc["hm"] = liveData.Humidity;
  doc["bp"] = liveData.Pressure;
  doc["tr"] = liveData.HourlyRain;
  doc["rs"] = liveData.RSSI;

  serializeJson(doc, buffer);
  SendUDPMessage(sdci->IP, sdci->port, buffer);

}

/*  Get status of logger. getDiskStats
    takes some time because of getting 
    the cluster count */
void GetStatus(SDcmd* sdci) {

// --------------------------  
  char lbuf[512]; // 217 bytes needed, actual 144

  char sl[20], su[20];
  disableCore0WDT(); // stop the watchdog during getting disk stats
  getDiskStats(sdci->active);
  enableCore0WDT();
  
  AddSizeSuffix(sl, diskInfo.SpaceLeft);
  AddSizeSuffix(su, diskInfo.SpaceUsed); 

  JsonDocument doc;
  doc["mi"] = sdci->cmd;
  doc["bd"] = (uint16_t) dateInfo.BootDate;
  doc["bt"] = (uint32_t) dateInfo.BootTime;
  doc["ct"] = (uint32_t) dateInfo.CurTime;
  doc["is"] = (uint8_t)  dateInfo.isSummer;
  doc["wr"] = (int8_t)   WiFi.RSSI();
  doc["rr"] = (int16_t)  radio.RSSI;
  doc["pr"] = (uint16_t) packetStats.packetsReceived;
  doc["pm"] = (uint16_t) packetStats.packetsMissed;
  doc["pc"] = (uint16_t) packetStats.crcErrors;
  doc["fc"] = (uint16_t) CountFiles(sdci); // takes time
  doc["bu"] = (char*) su; // text version of space used
  doc["bl"] = (char*) sl; // text version of space left
  doc["bs"] = (uint8_t)  wsData.Other.BatteryStatus;
  doc["ss"] = WiFi.SSID();
  doc["fv"] = FW_VERSION;

// Send body

  serializeJson(doc, lbuf);
  SendUDPMessage(sdci->IP, sdci->port, lbuf);

}

/*  
    *  Delete all files in the /Data folder leaving
    *  everything on the disk untouched.
*/
bool sd_DeleteDataFiles(SDcmd* sdci) {

  FsBaseFile cf;
  FsBaseFile root;
  uint16_t fcnt = 0;
  char buf[100];
  char name[32];
  bool ok = true;

  fcnt = 0;
  if (root = sd.open("/Data", O_READ)) {
    while(cf.openNext(&root, O_READ)) {
      cf.getName(name, 32);
      cf.close();
      if (!sd.remove(name)) {
        snprintf(buf, 100, "EraseAll - Unable to remove file %s", name);
        ok = false;
        break;
      } else {
        fcnt++;
      }
    }
    if (ok)
      snprintf(buf, 100, "EraseAll - %d files removed", name);
      
    Serial.print(buf);
    AppendLog(buf);
  }
  root.close();
  SendAck(sdci->IP, sdci->port, fcnt, lcAck, ok); 

  return ok;
}

// SdFat - disk into
void GetDiskInfo(DiskInfo * di) {

  SDcmd sdci;

  sdci.active = di->sdActive;
  
  if (di->sdActive) {
    uint32_t bpc = sd.vol()->bytesPerCluster();
    uint64_t tcc   = sd.vol()->clusterCount();
    uint32_t fcc = sd.vol()->freeClusterCount();

    di->SpaceLeft = (uint64_t) fcc * bpc;
    di->SpaceUsed = (uint64_t) (tcc - fcc) * bpc;
    strcpy(sdci.directory, "/Data");
    di->FileCount = CountFiles(&sdci);  
  }
}

/* Append the contents of the log cache.  The buffer in SDcmd
   is inadequate so the append is done elsewhere */
void AppendLogBuffer() {
  SDcmd sd;

  sd.cmd = lcAppendLogBuffer;
  sd.atdate = dateInfo.CurDate;
  strncpy(sd.filename, SYSLOGFILE, 32);
  strncpy(sd.directory, "/", 32);

  AddLocalRequestToQueue(sd);

}