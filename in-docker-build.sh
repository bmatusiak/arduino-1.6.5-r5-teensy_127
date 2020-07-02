#!/bin/bash -xe

# PLEASE NOTE. 
# Most people wont need the ability to compile firmware themselves, 
# as you can't load custom firmware unless you have a developer onlykey.
# Right now you can compile it if you want, but probably not worth your time lol
# 

#https://github.com/trustcrypto/OnlyKey-Firmware/issues/59

#disable screenSave blanks screen lockscreen (ubuntu)
#settings set org.gnome.settings-daemon.plugins.power active false
#settings set org.gnome.desktop.screensaver lock-enabled false

# install ubuntu deps
#sudo apt-get install git curl -y

#go to builds folder

 # Ensure we have a DISPLAY for the Arduino IDE
#/sbin/start-stop-daemon --start --quiet --pidfile /tmp/custom_xvfb_1.pid --make-pidfile --background --exec /usr/bin/xvfb-run -- :1 -ac -screen 0 1280x1024x16
#sleep 3
#export DISPLAY=:1.0

cd builds
rm -rf ./*

echo $(pwd)

#get firmware
git clone https://github.com/trustcrypto/OnlyKey-Firmware ./OnlyKey-Firmware
cd ./OnlyKey-Firmware
git checkout v0.2-beta.8
cd ../

#get arduino-ide
#curl https://downloads.arduino.cc/arduino-1.6.5-r5-linux64.tar.xz -o arduino.tar.xz
#get teensyduino
#curl https://www.pjrc.com/teensy/td_127/teensyduino.64bit -o teensyduino

#tar -xvf arduino.tar.xz
#chmod +x teensyduino
#./teensyduino

#git clone https://github.com/bmatusiak/arduino-1.6.5-r5-teensy_127
#mv arduino-1.6.5-r5-teensy_127/arduino-1.6.5-r5 .
#rm -rf ./arduino-1.6.5-r5-teensy_127
cp -a ../onlykey/arduino-1.6.5-r5 .

#rename firmware files to be replaced 
cd arduino-1.6.5-r5/hardware/teensy/avr/cores/teensy3

mv keylayouts.c keylayouts.c_orig
mv keylayouts.h keylayouts.h_orig
mv usb_desc.c usb_desc.c_orig
mv usb_desc.h usb_desc.h_orig
mv usb_dev.c usb_dev.c_orig
mv usb_dev.h usb_dev.h_orig
mv usb_rawhid.c usb_rawhid.c_orig
mv usb_rawhid.h usb_rawhid.h_orig
mv usb_keyboard.c usb_keyboard.c_orig
#gedit usb_keyboard.h

## back to desktop
cd ../../../../../..

#copy over custom files
cp ./OnlyKey-Firmware/*.c ./arduino-1.6.5-r5/hardware/teensy/avr/cores/teensy3/.
cp ./OnlyKey-Firmware/*.h ./arduino-1.6.5-r5/hardware/teensy/avr/cores/teensy3/.

# install custom libraries
cd ./arduino-1.6.5-r5/libraries
git init
git remote add origin https://github.com/trustcrypto/libraries
git pull origin v0.2-beta.8
cd ..

#old teensy dont work well, so we get the latest
#cd hardware/tools
#curl https://www.pjrc.com/teensy/teensy_linux64.tar.gz -o teensy_linux64.tar.gz
#rm ./teensy
#tar -xvf teensy_linux64.tar.gz
#cd ../..

#open teensy loader
#./hardware/tools/teensy &

# open ardiono with our firmware
#./arduino ../OnlyKey-Firmware/OnlyKey_Beta/OnlyKey_Beta.ino
/usr/bin/xvfb-run -- ./arduino --verify ../OnlyKey-Firmware/OnlyKey_Beta/OnlyKey_Beta.ino \
  --preferences-file ./preferences.txt \
  -v 

#before we compile click verify
# On the arduino UI change USB Type -> "Raw HID" and Board Type -> "Teensy 3.2/3.1".

#to find the firmware,  look at Teensy GUI, open Help->Verbose info
#you will see something like this that points to the firmware in tmp dir
#(loader): remote cmd from 14: "comment: Teensyduino 1.24 - LINUX64"
#(loader): remote cmd from 14: "dir:/tmp/build7833168683287571985.tmp/"
#(loader): remote cmd from 14: "file:OnlyKey.cpp.hex"
#(loader): File "OnlyKey.cpp.hex". 263104 bytes, 408% used

