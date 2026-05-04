#Configuring the Logger unit

Prior to use, the logger unit will require configuration.  Configuration requires that the ESP32 board is connected to a USB of a computer
and that the computer has a Serial terminal application installed.  The serial terminal can be of any type such as Visual Studio Code or YAT.
The serial terminal should be configured as 115200 baud, No parity, 8 bit, 1 stop bit and no flow control.  Once  configured and connected, open the
serial terminal.  This will display text as the ESP32 boots up.  Once the boot process is complete then press ? on the terminal.  The list of
configuration commands will be displayed. 

 Menu options

  ?           - Display help
 ---------------------"
  A           - Show SSID and Key
  A SSID Key  - Set SSID and Key
  ---------------------
  H           - Display Hostname
  H Hostname  - Set Hostname
  ---------------------
  I Yes       - Re-initialise Flash memory
  Df          - Display flash data
  Ds          - Display system data
  Dr          - Display RFM69 registers
  R Yes       - Restart the ESP
  ---------------------
  Z - Set the parameters for your timezone
  The first parameter is the NTP server address
  The second parameter is your timezone's offset in seconds from UTC
  The third parameter is the DST offset in seconds
  Example (UK) Z pool.ntp.org 0 3600
  Example (Singapore) Z pool.ntp.org 28800 0
  Example (Barbados) Z pool.ntp.org -14400 0
  Example (Alaska) Z pool.ntp.org -32400 3600 


In order to connect to your wireless network you will need the SSID and Key for your modem or wirless access point.

Find the SSID and Key and enter:

A Your_SSID Your_Key where "Your_SSID" and "Your_Key" are the SSID and key of your wireless network.  An example might be:

A PLUSNET-ABCD 7abcdef6a4

Now enter

R Yes

This will cause the ESP32 to reboot.  Watch the bootup information and provided the SSID and key have been correctly entered you should
see the ESP32 connect to your network and collect the current time.  The only other configuration required is your local timezone.  In the
UK the offset from UTC (GMT) is zero and the daylight saving time offset (when operating) is 3600.  The DST offset is regarded as 
Summer time offset relative to Winter time.

To enter the timezone information for the UK (UTC-0) would be:

Z pool.ntp.org 0 3600

This would set no offset from UTC and one hour positive offset for DST when it is operating.

To enter the timezone information if you are in New York, USA (UTC-5)

Z pool.ntp.org -18000 3600

To enter the timezone information if you are in Sydney, Australia (UTC+10)

Z pool.ntp.org 36000 3600

To enter the timezone information if you are in Togo, West Africa which does not observe DST

Z pool.ntp.org 0 0 

Set the hostname of your logger.  The default hostname is WS_LOGGER you may change this if required

H NewHostName

example

H WS_LOGGER_2

This completes the configuration. 
