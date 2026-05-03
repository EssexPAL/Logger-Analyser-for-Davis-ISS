/*
   Last Modified Time: December 8, 2025 at 6:33:26 AM
*/

#ifndef ISSFLASH_h
#define ISSFLASH_h

#define FLASHHEADER     "{*@&$#INT#$&@*}\0"
#define DATASIZE        sizeof(TFlashData)
#define SSIDENTRIES     5
#define SSIDNAMESIZE    32
#define SSIDKEYSIZE     32
#define SSIDSIZE        (SSIDKEYSIZE + SSIDNAMESIZE) * SSIDENTRIES 
#define TZLENGTH        30

// just used for saving/restoring to/from flash

struct TSSID {
    char    Name[SSIDNAMESIZE];
    char    Key[SSIDKEYSIZE];
};

struct TSSIDLIST { TSSID Entry[5]; };

//struct TSSIDInfo { TSSID List[5]; };

struct TFlashData {
    char        Header[16];
    bool        UseDST;
    int32_t     UTC_Offset;   // local timezone offset from UTC in seconds
    int32_t     DST_Offset;   // DST offset from UTC in seconds
    char        hostName[16]; 
    byte        ssid[SSIDSIZE];
};

void InitFlash();
void DumpFlashData(const char * Text);
bool ReadFlashData(TFlashData * fD, TSSIDLIST * sL);
void WriteFlashData(TFlashData *Fd, TSSIDLIST *Sd, bool Init);


#endif

