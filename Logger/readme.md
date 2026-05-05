**Configuring the Logger unit**

Please see the "Logger Configuration Instructions.pdf" for information on making first time settings.

-------------------------------------------------------------------------   

**Dependencies for Logger** 

Adafruit BMP280 Library     https://github.com/adafruit/Adafruit_BMP280_Library<br>
Adafruit BusIO              https://github.com/adafruit/Adafruit_BusIO<br>
Adafruit Unified Sensor     https://github.com/adafruit/Adafruit_Sensor<br>
ArduinoJson                 https://github.com/bblanchon/ArduinoJson<br>
CRC                         https://github.com/RobTillaart/CRC<br>
NTP Client                  https://github.com/arduino-libraries/NTPClient<br>
SdFat                       https://github.com/greiman/SdFat<br>

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
