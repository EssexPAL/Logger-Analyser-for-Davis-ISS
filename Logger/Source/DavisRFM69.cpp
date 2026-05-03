/*
   Last Modified Time: April 2, 2026 at 7:12:42 AM
*/

// Driver implementation for HopeRF RFM69W/RFM69HW, Semtech SX1231/1231H used for
// compatibility with the frequency hopped, spread spectrum signals from a Davis Instrument
// wireless Integrated Sensor Suite (ISS)
//
// This is part of the DavisRFM69 library from https://github.com/dekay/DavisRFM69
// (C) DeKay 2014 dekaymail@gmail.com
//
// As I consider this to be a derived work for now from the RFM69W library from LowPowerLab,
// and ammendments by DeKay it is released under the same Creative Commons Attrib Share-Alike License
// You are free to use/extend this library but please abide with the CC-BY-SA license:
// http://creativecommons.org/licenses/by-sa/3.0/

// This is a modified version of dekays RFM69 library intended for use ONLY with the ESP32

#include <DavisRFM69.h>
#include <RFM69registers.h>
#include <SPI.h>
#include <flashled.h>

//#define NORFM69WAIT

volatile uint8_t  DavisRFM69::DATA[DAVIS_PACKET_LEN];
volatile uint8_t  DavisRFM69::_mode;  // current transceiver state
volatile bool     DavisRFM69::_packetReceived = false;
volatile uint8_t  DavisRFM69::CHANNEL = 0;
volatile int16_t  DavisRFM69::RSSI;   // RSSI measured immediately after payload reception
DavisRFM69*       DavisRFM69::selfPointer;

extern uint32_t RXFlashCount;
extern uint32_t SDFlashCount;
extern flashLED redLED;
extern flashLED grnLED;

const uint8_t CONFIG[][2] =
  {
    /* 0x01 */ { REG_OPMODE, RF_OPMODE_SEQUENCER_ON | RF_OPMODE_LISTEN_OFF | RF_OPMODE_STANDBY },
    /* 0x02 */ { REG_DATAMODUL, RF_DATAMODUL_DATAMODE_PACKET | RF_DATAMODUL_MODULATIONTYPE_FSK | RF_DATAMODUL_MODULATIONSHAPING_10 }, // Davis uses Gaussian shaping with BT=0.5
    /* 0x03 */ { REG_BITRATEMSB, RF_BITRATEMSB_19200}, // Davis uses a datarate of 19.2 KBPS
    /* 0x04 */ { REG_BITRATELSB, RF_BITRATELSB_19200},
    /* 0x05 */ { REG_FDEVMSB, RF_FDEVMSB_4800}, // Davis uses a deviation of 4.8 kHz on Rx
    /* 0x06 */ { REG_FDEVLSB, RF_FDEVLSB_4800},
    /* 0x07 to 0x09 are REG_FRFMSB to LSB. No sense setting them here. Done in main routine.
    /* 0x0B */ { REG_AFCCTRL, RF_AFCCTRL_LOWBETA_OFF }, // TODO: Should use LOWBETA_ON, but having trouble getting it working
    // looks like PA1 and PA2 are not implemented on RFM69W, hence the max output power is 13dBm
    // +17dBm and +20dBm are possible on RFM69HW
    // +13dBm formula: Pout=-18+OutputPower (with PA0 or PA1**)
    // +17dBm formula: Pout=-14+OutputPower (with PA1 and PA2)**
    // +20dBpaym formula: Pout=-11+OutputPower (with PA1 and PA2)** and high power PA settings (section 3.3.7 in datasheet)
    ///* 0x11 */ { REG_PALEVEL, RF_PALEVEL_PA0_ON | RF_PALEVEL_PA1_OFF | RF_PALEVEL_PA2_OFF | RF_PALEVEL_OUTPUTPOWER_11111},
    ///* 0x13 */ { REG_OCP, RF_OCP_ON | RF_OCP_TRIM_95 }, //over current protection (default is 95mA)
    /* 0x18 */ { REG_LNA, RF_LNA_ZIN_50 | RF_LNA_GAINSELECT_AUTO}, // Not sure which is correct!
    // RXBW defaults are { REG_RXBW, RF_RXBW_DCCFREQ_010 | RF_RXBW_MANT_24 | RF_RXBW_EXP_5} (RxBw: 10.4khz)
    /* 0x19 */ { REG_RXBW, RF_RXBW_DCCFREQ_010 | RF_RXBW_MANT_20 | RF_RXBW_EXP_4 }, // Use 25 kHz BW (BitRate < 2 * RxBw)
    /* 0x1A */ { REG_AFCBW, RF_RXBW_DCCFREQ_010 | RF_RXBW_MANT_20 | RF_RXBW_EXP_3 }, // Use double the bandwidth during AFC as reception
    /* 0x1B - 0x1D These registers are for OOK.  Not used */
    /* 0x1E */ { REG_AFCFEI, RF_AFCFEI_AFCAUTOCLEAR_ON | RF_AFCFEI_AFCAUTO_ON },
    /* 0x1F & 0x20 AFC MSB and LSB values, respectively */
    /* 0x21 & 0x22 FEI MSB and LSB values, respectively */
    /* 0x23 & 0x24 RSSI MSB and LSB values, respectively */
    /* 0x25 */ { REG_DIOMAPPING1, RF_DIOMAPPING1_DIO0_01 }, //DIO0 is the only IRQ we're using
    /* 0x26 RegDioMapping2 */
    /* 0x27 RegIRQFlags1 */
    /* 0x28 */ { REG_IRQFLAGS2, RF_IRQFLAGS2_FIFOOVERRUN }, // Reset the FIFOs. Fixes a problem I had with bad first packet.
    /* 0x29 */ { REG_RSSITHRESH, 170 }, //must be set to dBm = (-Sensitivity / 2) - default is 0xE4=228 so -114dBm
    /* 0x2a & 0x2b RegRxTimeout1 and 2, respectively */
    /* 0x2c RegPreambleMsb - use zero default */
    /* 0x2d */ { REG_PREAMBLELSB, 4 }, // Davis has four preamble bytes 0xAAAAAAAA
    /* 0x2e */ { REG_SYNCCONFIG, RF_SYNC_ON | RF_SYNC_FIFOFILL_AUTO | RF_SYNC_SIZE_2 | RF_SYNC_TOL_2 },  // Allow a couple erros in the sync word
    /* 0x2f */ { REG_SYNCVALUE1, 0xcb }, // Davis ISS first sync byte. http://madscientistlabs.blogspot.ca/2012/03/first-you-get-sugar.html
    /* 0x30 */ { REG_SYNCVALUE2, 0x89 }, // Davis ISS second sync byte.
    /* 0x31 - 0x36  REG_SYNCVALUE3 - 8 not used */
    /* 0x37 */ { REG_PACKETCONFIG1, RF_PACKET1_FORMAT_FIXED | RF_PACKET1_DCFREE_OFF | RF_PACKET1_CRC_OFF | RF_PACKET1_CRCAUTOCLEAR_OFF | RF_PACKET1_ADRSFILTERING_OFF }, // Fixed packet length and we'll check our own CRC
    /* 0x38 */ { REG_PAYLOADLENGTH, DAVIS_PACKET_LEN }, // Davis sends 10 bytes of payload, including CRC that we check manually (Note: includes 2 byte re-transmit CRC).
    //* 0x39 */ { REG_NODEADRS, nodeID }, // Turned off because we're not using address filtering
    //* 0x3a */ { REG_BROADCASTADRS, RF_BROADCASTADDRESS_VALUE }, // Not using this
    /* 0x3b REG_AUTOMODES - Automatic modes are not used in this implementation. */
    /* 0x3c */ { REG_FIFOTHRESH, RF_FIFOTHRESH_TXSTART_FIFOTHRESH | 0x09 }, // TX on FIFO having more than nine bytes - we'll implement the re-transmit CRC
    /* 0x3d */ { REG_PACKETCONFIG2, RF_PACKET2_RXRESTARTDELAY_2BITS | RF_PACKET2_AUTORXRESTART_ON | RF_PACKET2_AES_OFF }, //RXRESTARTDELAY must match transmitter PA ramp-down time (bitrate dependent)
    /* 0x3e - 0x4d  AES Key not used in this implementation */
    /* 0x6F */ { REG_TESTDAGC, RF_DAGC_IMPROVED_LOWBETA0 }, // // TODO: Should use LOWBETA_ON, but having trouble getting it working
    /* 0x71 */ { REG_TESTAFC, 0 }, // AFC Offset for low mod index systems
    {255, 0}
  };  

/** If intPin is zero then no interrupt will be assigned.
// The internally provided interrupt does very little */
bool DavisRFM69::initialize(uint8_t intPin, SPIClass* _lspi) {

/* use either the spi ss pin or provided one */
  _xspi = *_lspi;

  if(_xspi.pinSS() != -1) 
    _slaveSelectPin = _xspi.pinSS();

  _interruptNum   = intPin;             //  <--- Mod
  digitalWrite(_slaveSelectPin, HIGH);  //  <--- Mod
  pinMode(_slaveSelectPin, OUTPUT);     //  <--- Mod

  _xspi.begin();
  
  uint32_t SyncStart = millis();
  bool SyncFail = false;
//  RxIsOn = true;
  //LastChannel = 0;

  do { 
    writeReg(REG_SYNCVALUE1, 0xaa); 
    #ifndef NORFM69WAIT
      if ((millis() - SyncStart) > 5000) {
        SyncFail = true;
        break;
      }
    #endif

  } while (readReg(REG_SYNCVALUE1) != 0xaa);

  if (!SyncFail) {
    do 
      writeReg(REG_SYNCVALUE1, 0x55); 
    while (readReg(REG_SYNCVALUE1) != 0x55);

    for (uint8_t i = 0; CONFIG[i][0] != 255; i++) {
      writeReg(CONFIG[i][0], CONFIG[i][1]);
    }

    setHighPower(_isRFM69HW); //called regardless if it's a RFM69W or RFM69HW
    setMode(RF69_MODE_STANDBY);
    while ((readReg(REG_IRQFLAGS1) & RF_IRQFLAGS1_MODEREADY) == 0x00)
      ; // Wait for ModeReady
  
  // if intPin is zero then dont configure an interrupt
    if (intPin != 0) {
      #if defined (ESP8266) || defined (ESP32) // <-- mod
        attachInterrupt(digitalPinToInterrupt(_interruptNum), DavisRFM69::isr0, RISING);
      #else
        attachInterrupt(_interruptNum, DavisRFM69::isr0, RISING);
      #endif
    }

    selfPointer = this;
  }
  
  return SyncFail;    
}
// --------------------------


void DavisRFM69::setRegisters(char * text = 0) {

  for (uint8_t i = 0; CONFIG[i][0] != 255; i++) {
    writeReg(CONFIG[i][0], CONFIG[i][1]);
  }
  
  setHighPower(_isRFM69HW); //called regardless if it's a RFM69W or RFM69HW
  setMode(RF69_MODE_STANDBY);
  while ((readReg(REG_IRQFLAGS1) & RF_IRQFLAGS1_MODEREADY) == 0x00)
      ; // Wait for ModeReady

}

void DavisRFM69::CollectData() {
  
  RSSI = readRSSI();  // RSSI is set when the data is detected so available later

  if (_mode == RF69_MODE_RX && (readReg(REG_IRQFLAGS2) & RF_IRQFLAGS2_PAYLOADREADY)) {
    setMode(RF69_MODE_STANDBY);
    select();   // Select RFM69 module, disabling interrupts
    _xspi.transfer(REG_FIFO & 0x7f);
  
    for (uint8_t i = 0; i < DAVIS_PACKET_LEN; i++) 
      DATA[i] = reverseBits(_xspi.transfer(0)) ;
    
    _packetReceived = true;
    unselect();  // Unselect RFM69 module, enabling interrupts
  }
}

#if defined (ESP32) 
  void IRAM_ATTR DavisRFM69::isr0() {
    selfPointer->interruptHandler(); 
  }
#else
  void DavisRFM69::isr0() { 
    selfPointer->interruptHandler(); 
  }
#endif
  
void DavisRFM69::interruptHandler() {
  
    hop();
  }

bool DavisRFM69::canSend()
{
  // If signal stronger than -100dBm is detected assume channel activity
  if (_mode == RF69_MODE_RX && readRSSI() < CSMA_LIMIT)
  {
    setMode(RF69_MODE_STANDBY);
    return true;
  }
  return false;
}

void DavisRFM69::send(const void* buffer, uint8_t bufferSize)
{
  writeReg(REG_PACKETCONFIG2, (readReg(REG_PACKETCONFIG2) & 0xFB) | RF_PACKET2_RXRESTART); // avoid RX deadlocks
  while (!canSend()) receiveDone();
  sendFrame(buffer, bufferSize);
}

void DavisRFM69::sendFrame(const void* buffer, uint8_t bufferSize)
{
  setMode(RF69_MODE_STANDBY); //turn off receiver to prevent reception while filling fifo
  while ((readReg(REG_IRQFLAGS1) & RF_IRQFLAGS1_MODEREADY) == 0x00)
    ; // Wait for ModeReady
  writeReg(REG_DIOMAPPING1, RF_DIOMAPPING1_DIO0_00); // DIO0 is "Packet Sent"
  if (bufferSize > DAVIS_PACKET_LEN) 
    bufferSize = DAVIS_PACKET_LEN;

  uint16_t crc = crc16_ccitt((volatile uint8_t *)buffer, 6);
  //write to FIFO
  select();
  SPI.transfer(REG_FIFO | 0x80);

  for (uint8_t i = 0; i < bufferSize; i++)
    _xspi.transfer(reverseBits(((uint8_t*)buffer)[i]));

  _xspi.transfer(reverseBits(crc >> 8));
  _xspi.transfer(reverseBits(crc & 0xff));
  unselect();

  // no need to wait for transmit mode to be ready since its handled by the radio
  setMode(RF69_MODE_TX);
  while (digitalRead(_interruptPin) == 0); //wait for DIO0 to turn HIGH signalling transmission finish
  setMode(RF69_MODE_STANDBY);
}

void DavisRFM69::setChannel(uint8_t channel)
{
  CHANNEL = channel % DAVIS_FREQ_TABLE_LENGTH;

  writeReg(REG_FRFMSB, pgm_read_byte(&FRF[CHANNEL][0]));
  writeReg(REG_FRFMID, pgm_read_byte(&FRF[CHANNEL][1]));
  writeReg(REG_FRFLSB, pgm_read_byte(&FRF[CHANNEL][2]));
  receiveBegin();
}

void DavisRFM69::hop()
{
  setChannel(++CHANNEL);
}

// Data bytes over the air from the ISS least significant bit first. Fix them as we go. From
// http://www.ocf.berkeley.edu/~wwu/cgi-bin/yabb/YaBB.cgi?board=riddles_cs;action=display;num=1103355188
uint8_t DavisRFM69::reverseBits(uint8_t b)
{
  b = ((b & 0b11110000) >>4 ) | ((b & 0b00001111) << 4);
  b = ((b & 0b11001100) >>2 ) | ((b & 0b00110011) << 2);
  b = ((b & 0b10101010) >>1 ) | ((b & 0b01010101) << 1);

  return(b);
}

// Davis CRC calculation from http://www.menie.org/georges/embedded/
uint16_t DavisRFM69::crc16_ccitt(volatile uint8_t *buf, uint8_t len, uint16_t initCrc)
{
  uint16_t crc = initCrc;
  while( len-- ) {
    crc ^= *(char *)buf++ << 8;
    for(uint8_t i = 0; i < 8; ++i ) {
      if( crc & 0x8000 )
        crc = (crc << 1) ^ 0x1021;
      else
        crc = crc << 1;
    }
  }
  return crc;
}

void DavisRFM69::setFrequency(uint32_t FRF)
{
  writeReg(REG_FRFMSB, FRF >> 16);
  writeReg(REG_FRFMID, FRF >> 8);
  writeReg(REG_FRFLSB, FRF);
}

void DavisRFM69::setMode(uint8_t newMode)
{
  //// Serial.println(newMode);
  if (newMode == _mode) return;

  switch (newMode) {
    case RF69_MODE_TX:
      writeReg(REG_OPMODE, (readReg(REG_OPMODE) & 0xE3) | RF_OPMODE_TRANSMITTER);
      if (_isRFM69HW) setHighPowerRegs(true);
      break;
    case RF69_MODE_RX:
      writeReg(REG_OPMODE, (readReg(REG_OPMODE) & 0xE3) | RF_OPMODE_RECEIVER);
//      RxIsOn = true;
      if (_isRFM69HW) setHighPowerRegs(false);
      break;
    case RF69_MODE_SYNTH:
      writeReg(REG_OPMODE, (readReg(REG_OPMODE) & 0xE3) | RF_OPMODE_SYNTHESIZER);
      break;
    case RF69_MODE_STANDBY:
      writeReg(REG_OPMODE, (readReg(REG_OPMODE) & 0xE3) | RF_OPMODE_STANDBY);
      break;
    case RF69_MODE_SLEEP:
      writeReg(REG_OPMODE, (readReg(REG_OPMODE) & 0xE3) | RF_OPMODE_SLEEP);
//      RxIsOn = false;
      break;
    default: return;
  }

  // we are using packet mode, so this check is not really needed
  // but waiting for mode ready is necessary when going from sleep because the FIFO may not
  // be immediately available from previous mode
  while (_mode == RF69_MODE_SLEEP && (readReg(REG_IRQFLAGS1) & RF_IRQFLAGS1_MODEREADY) == 0x00); // Wait for ModeReady

  _mode = newMode;
 
}

void DavisRFM69::sleep() {
  setMode(RF69_MODE_SLEEP);
}

//void DavisRFM69::isr0() { 
//  selfPointer->interruptHandler(); 
//}

void DavisRFM69::receiveBegin() {
  _packetReceived = false;
  if (readReg(REG_IRQFLAGS2) & RF_IRQFLAGS2_PAYLOADREADY)
    writeReg(REG_PACKETCONFIG2, (readReg(REG_PACKETCONFIG2) & 0xFB) | RF_PACKET2_RXRESTART); // avoid RX deadlocks

  writeReg(REG_DIOMAPPING1, RF_DIOMAPPING1_DIO0_01); //set DIO0 to "PAYLOADREADY" in receive mode
  setMode(RF69_MODE_RX);
}

bool DavisRFM69::receiveDone() {
  return _packetReceived;
}

int16_t DavisRFM69::readRSSI(bool forceTrigger) {
  int16_t rssi = 0;
  if (forceTrigger)
  {
    // RSSI trigger not needed if DAGC is in continuous mode
    writeReg(REG_RSSICONFIG, RF_RSSI_START);
    while ((readReg(REG_RSSICONFIG) & RF_RSSI_DONE) == 0x00); // Wait for RSSI_Ready
  }
  rssi = -readReg(REG_RSSIVALUE);
  rssi >>= 1;
  return rssi;
}

uint8_t DavisRFM69::readReg(uint8_t addr)
{
  select();
  _xspi.transfer(addr & 0x7F);
  uint8_t regval = _xspi.transfer(0);
  unselect();
  return regval;
}

void DavisRFM69::writeReg(uint8_t addr, uint8_t value)
{
  select();
  _xspi.transfer(addr | 0x80);
  _xspi.transfer(value);
  unselect();
}


// Select the transceiver
void DavisRFM69::select() {
  noInterrupts();
  
  // Set RFM69 SPI settings
  _xspi.setDataMode(SPI_MODE0);
  _xspi.setBitOrder(MSBFIRST);
  _xspi.setClockDivider(SPI_CLOCK_DIV4); // decided to slow down from DIV2 after SPI stalling in some instances, especially visible on mega1284p when RFM69 and FLASH chip both present
  digitalWrite(_slaveSelectPin, LOW);
}

// Unselect the transceiver chip
void DavisRFM69::unselect() {
  digitalWrite(_slaveSelectPin, HIGH);
  // Restore SPI settings to what they were before talking to RFM69
  
  interrupts();
}

void DavisRFM69::setHighPower(bool onOff) {
  _isRFM69HW = onOff;
  writeReg(REG_OCP, _isRFM69HW ? RF_OCP_OFF : RF_OCP_ON);
  if (_isRFM69HW) // Turning ON
    writeReg(REG_PALEVEL, (readReg(REG_PALEVEL) & 0x1F) | RF_PALEVEL_PA1_ON | RF_PALEVEL_PA2_ON); //enable P1 & P2 amplifier stages
  else
    writeReg(REG_PALEVEL, RF_PALEVEL_PA0_ON | RF_PALEVEL_PA1_OFF | RF_PALEVEL_PA2_OFF | _powerLevel); //enable P0 only
}

void DavisRFM69::setHighPowerRegs(bool onOff) {
  writeReg(REG_TESTPA1, onOff ? 0x5D : 0x55);
  writeReg(REG_TESTPA2, onOff ? 0x7C : 0x70);
}

void DavisRFM69::setCS(uint8_t newSPISlaveSelect) {
  _slaveSelectPin = newSPISlaveSelect;
  digitalWrite(_slaveSelectPin, HIGH);
  pinMode(_slaveSelectPin, OUTPUT);
}

char * atoh(char * buf, uint8_t val) {

  uint8_t msn = val >> 4;
  uint8_t lsn = val & 0x0F;

  if (msn < 10) {
    buf[0] = 48 + msn;
  } else {
    buf[0] = 55 + msn;
  }

  if (lsn < 10) {
    buf[1] = 48 + lsn;
  } else {
    buf[1] = 55 + lsn;
  }
  buf[2] = ' ';
  buf[3] = 0;
  return buf;
}

void DavisRFM69::readSetRegs(char * dbuf = 0) {

  uint8_t regVal;
  char hexbuf[10];
  char outbuf[300];

  outbuf[0] = 0;

  for (uint8_t idx = 0; CONFIG[idx][0] != 255; idx++) {
    select();
    _xspi.transfer(CONFIG[idx][0] & 0x7f); // Send address + r/w bit
    regVal = _xspi.transfer(0);
    unselect();
  
    sprintf(hexbuf, "%02X:%02X ", CONFIG[idx][0], regVal);
    strcat(outbuf, hexbuf);
    if ((idx & 7) == 7) {
      strcat(outbuf, "\r\n");
    }
  }
  
  if(dbuf == 0) ;
    // Serial.print(outbuf);
  else
    strcpy(dbuf, outbuf);
}

// For debugging - a shorter form than the original
void DavisRFM69::readAllRegs(char * dbuf = 0)
{
  uint8_t regVal;
  char buf[100], hexbuf[10];
  char outbuf[300];

  buf[0] = 0;
  outbuf[0] = 0;

  for (uint8_t regAddr = 0; regAddr <= 0x4F; regAddr++) {   
    if (regAddr > 0) {
      select();
      _xspi.transfer(regAddr & 0x7f); // Send address + r/w bit
      regVal = _xspi.transfer(0);
      unselect();
      atoh(hexbuf, regVal);
    } else {
      strcpy(hexbuf, "-- ");
    }

    if ((regAddr % 16) == 0) {
      sprintf(buf, "%02X: ", regAddr);
    }
    
    strcat(buf, hexbuf);

    if (((regAddr % 16) == 15) || (regAddr == 0x4F)) {
      strcat(outbuf, buf);
      strcat(outbuf, "\r\n");
      buf[0] = 0;
    }
  }

   unselect();

  if (!dbuf == 0) {
    strcpy(dbuf, outbuf);
    Serial.println(dbuf);
  }
}

uint8_t DavisRFM69::readTemperature(uint8_t calFactor)  // Returns centigrade
{
  setMode(RF69_MODE_STANDBY);
  writeReg(REG_TEMP1, RF_TEMP1_MEAS_START);
  while ((readReg(REG_TEMP1) & RF_TEMP1_MEAS_RUNNING))
    ;
  return ~readReg(REG_TEMP2) + COURSE_TEMP_COEF + calFactor; //'complement'corrects the slope, rising temp = rising val
} // COURSE_TEMP_COEF puts reading in the ballpark, user can add additional correction

void DavisRFM69::rcCalibration()
{
  writeReg(REG_OSC1, RF_OSC1_RCCAL_START);
  while ((readReg(REG_OSC1) & RF_OSC1_RCCAL_DONE) == 0x00);
}

// vim: et:sts=2:ts=2:sw=2
