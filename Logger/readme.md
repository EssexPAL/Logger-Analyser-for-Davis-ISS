**Configuring the Logger unit**

#WARNING<br> **Dont attach external power to the ESP32 whilst it is connected to the computers USB.**
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
