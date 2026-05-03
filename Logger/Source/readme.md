Source code (C++) for the datalogger.  The datalogger collects RF data directly from the weather station.  Please note that th RFM69 configuration needs
to be edited for region in which it is to be used.  This affects the frequencies and the number of channels in use.  Inside the EU the frequencies
are in the 868MHz range and only 5 channels are used, this is different elsewhere.

Dependencies and PlatformIO.ini

Adafruit BMP280 Library     https://github.com/adafruit/Adafruit_BMP280_Library
Adafruit BusIO              https://github.com/adafruit/Adafruit_BusIO
Adafruit Unified Sensor     https://github.com/adafruit/Adafruit_Sensor
ArduinoJson                 https://github.com/bblanchon/ArduinoJson
CRC                         https://github.com/RobTillaart/CRC
NTP Client                  https://github.com/arduino-libraries/NTPClient
SdFat                       https://github.com/greiman/SdFat

-------------------------------------------------------------------------   

; PlatformIO Project Configuration File
;
;   Build options: build flags, source filter
;   Upload options: custom upload port, speed and extra flags
;   Library options: dependencies, extra library storages
;   Advanced options: extra scripting
;
; Please visit documentation for the other options and examples
; https://docs.platformio.org/page/projectconf.html

[env:upesy_wroom]
platform = espressif32
board = upesy_wroom
framework = arduino
lib_ldf_mode = chain
monitor_speed = 115200
lib_deps =
    file://D:\Arduino\Projects\libraries\Adafruit_BMP280_Library
    file://D:\Arduino\Projects\libraries\Adafruit_BusIO
    file://D:\Arduino\Projects\libraries\CRC
    bblanchon/ArduinoJson @ ^7.4.3
    file://D:\Arduino\Projects\libraries\SdFat
    file://D:\Arduino\Projects\libraries\NTPClient
