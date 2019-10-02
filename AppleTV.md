Quick Start
Installation instructions for getting started with the UCM/Pi

What is this all about
This guide is intended to help new users of the UCM/Pi (a Universal Communication Module which supports a Raspberry Pi CM3 compatible single board computer) install the operating system, configure the device, install Node-Red and related code developed by alphaWerk to interface Node-Red to the Cytech Comfort Home Automation and Security System

Note: This guide is still in beta, as is the alphaWerk Node-Red modules and associated code.

Getting Started
To get started, you will need

A Cytech Comfort Alarm system (www.cytech.com)
A UCM/Pi available from Cytech
A Raspberry Pi CM3 or compatible device with onboard eMMC storage (min 4Gb)
A Windows, Mac or Linux computer
This guide below assumes you have performed the following steps:

Flashed your UCM/Pi with the latest version of Raspbian Lite or Raspbian (https://www.raspberrypi.org/downloads/raspbian/)
Have been able to connect the UCM/Pi to your network and Confort system, set a hostname and login.
Configuring the Operating System
Enable the serial port
sudo raspi-config from the command line.

Select Menu 5 Interfacing Options
Select Menu P6 Serial
Answer <No> to Would you like a login shell to be acccessible over serial?
Answer <Yes> to Would you like the serial port hardware to be enable?
Select Menu 7 Advanced Options
Select Menu A1 Expand Filesystem
Select <Finish> and <Yes> if prompted to reboot.
Log back into the UCM/Pi once it has rebooted.

Edit /boot/config.txt
sudo nano /boot/config.txt from the command line.

add the following to the bottom of the text file.

enable_uart=1
dtoverlay=pi3-disable-bt
dtparam=uart0=on
Installing Node-Red and alphaWerk components
execute the following command

curl -sL https://uhai.alphawerk.co.uk/scripts/quickstart | bash -
All Done
Navigate to http://<IP Address>:1080 in a browser to create a user account and start using Node-Red.
