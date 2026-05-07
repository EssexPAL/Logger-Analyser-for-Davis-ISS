# A logger for Davis ISS weather stations and downloader/Analyser for the weather data<br>

<img width="1202" height="846" alt="WsLogger" src="https://github.com/user-attachments/assets/11bbf9ed-ad7f-4a97-b7ef-37da9e34d851" />

<br><br>**An RF data logger for use with a Davis ISS weather station**

The goal of this project is to directly collect data (via RF) from a Davis ISS weather station.  Once the data is collected 
then it is available for analysis.  The data logging needed to be done in a way which required no modifications or additions
to the Davis ISS and should be completely automatic.

The project comprises two halves<br>
  1). **Data logger** - Uses an ESP32 and implmented using C++.  Collects the RF data from a Davis ISS weather station.<br>
  2). **Data Analyser** Application - This runs under Windows 7/8/10/11 and is implemented using Delphi (Pascal).<br>

**Data Logger** - The data logger monitors and collects data directly from a Davis ISS weather station.  It is intended for use on a 
simple, working, Davis ISS system (ISS and console). The weather station transmits data packets at 2.56S intervals.  The contents of each packet
varies and is identified within the packet.  Every packet contains wind direction and wind speed data.  In addition,
cyclically, the packets also contain temperature, humidity and rainfall data.  The ISS does not deliver barometric
pressure information, this is incorporated into the logger.  Data from the packets are collected and stored in
ESP32 ram.  The information is then averaged and saved to SD disk once per minute.  Each day has its own file on the disk
with 1440 one minute data samples.  A 4GB SD disk should hold 59000+ files (160+ years).  The data file is text, all numeric
values are in hexadecimal.  The logger makes the data available to computers on your private wireless network via UDP.
The Davis information and code for the RFM69 receiver module are a slightly mofiied version of DeKay's excellent work.
DeKay https://github.com/dekay/DavisRFM69.

**Limitations** - I am in the UK so I have only been able to test the software using my European version ISS.  The channel agility
is different between countries, the european version is much simpler than other countries (just 5 channels).
In addition I only have an ISS and Console so its a very simple system.  The logger has been running for eighteen months without
any problems (but a few software updates).

**Data Analyser** - The analyser application collects data directly from the logger using UDP.  The current version of the
analyser can be configured to automatically download new data at startup and keep it updated once an hour.  The application will
also allow you to manually to get the directory from the SD disk on the logger and select the files you wish to download.
Once downloaded the files can be selected amd imported into the data table, once in the table the data is available for
analysis/display.  The data files are text based comprising 1441 lines.  It may be viewed as a single day, one/two weeks, 
one month, three months, six months, tweleve months and 24 months.  The results may be printed.
The software is 32 bit and was developed using Delphi XE4.

The logger will require a development environment in order to program the ESP32, something like VSC with PlatforIO.<br>
Changing the analyser code will require that you have Delphi installed.<br>
If you have no desire to delve into the Delphi code then there is an installer which will install the current version.

**WsClient Installation**

The WsClientInstaller.exe installation file has been virus checked however the installer was built using Inno Setup installation compiler.  
This uses LZMA compression which some virus checkers wrongly consider a threat.

Run WsClientInstaller.exe and follow the instructions.  The installation is a single user type.  On completion the application will run.  
During the installation You will be prompted to enter the IP address of the logger unit.

The installation includes some test data (07/04/26 to 29/04/26).  This data serves to demonstrate the operation of the application.  
Select a date within the range and press one of the action buttons, e.g. “Temperature”.  Evaluate all the actions.

Once you have finished with the test data use the “Database->Empty Database” menu option to remove it.  Once you have removed the 
test data you can proceed to download data stored on the Logger unit using the “Import Data” menu option.







  
