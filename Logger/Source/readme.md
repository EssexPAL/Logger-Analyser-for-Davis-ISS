Source code (C++) for the datalogger.  The datalogger collects RF data directly from the weather station.  Please note that th RFM69 configuration needs
to be edited for region in which it is to be used.  This affects the frequencies and the number of channels in use.  Inside the EU the frequencies
are in the 868MHz range and only 5 channels are used, this is different elsewhere.

Dependencies and PlatformIO.ini

Adafruit BMP280 Library     https://github.com/adafruit/Adafruit_BMP280_Library<br>
Adafruit BusIO              https://github.com/adafruit/Adafruit_BusIO<br>
Adafruit Unified Sensor     https://github.com/adafruit/Adafruit_Sensor<br>
ArduinoJson                 https://github.com/bblanchon/ArduinoJson<br>
CRC                         https://github.com/RobTillaart/CRC<br>
NTP Client                  https://github.com/arduino-libraries/NTPClient<br>
SdFat                       https://github.com/greiman/SdFat<br>

-------------------------------------------------------------------------   

; PlatformIO Project Configuration File<br>
;<br>
;   Build options: build flags, source filter<br>
;   Upload options: custom upload port, speed and extra flags<br>
;   Library options: dependencies, extra library storages<br>
;   Advanced options: extra scripting<br>
;<br>
; Please visit documentation for the other options and examples<br>
; https://docs.platformio.org/page/projectconf.html<br>
<br>
[env:upesy_wroom]<br>
platform = espressif32<br>
board = upesy_wroom<br>
framework = arduino<br>
lib_ldf_mode = chain<br>
monitor_speed = 115200<br>
lib_deps =<br>
    file://D:\Arduino\Projects\libraries\Adafruit_BMP280_Library<br>
    file://D:\Arduino\Projects\libraries\Adafruit_BusIO<br>
    file://D:\Arduino\Projects\libraries\CRC<br>
    bblanchon/ArduinoJson @ ^7.4.3<br>
    file://D:\Arduino\Projects\libraries\SdFat<br>
    file://D:\Arduino\Projects\libraries\NTPClient<br>
