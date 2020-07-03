#!/bin/bash -xe

# PLEASE NOTE. 
# Most people wont need the ability to compile firmware themselves, 
# as you can't load custom firmware unless you have a developer onlykey.
# Right now you can compile it if you want, but probably not worth your time lol
# 


#https://github.com/trustcrypto/OnlyKey-Firmware/issues/59


#firmware_git_path=https://github.com/trustcrypto/OnlyKey-Firmware
#libraries_git_path=https://github.com/trustcrypto/libraries
##you can use local git repos, this file is `/onlykey/in-docker-build.sh`, OnlyKey-Firmware, libraries are .gitignored
firmware_git_path=/onlykey/OnlyKey-Firmware
libraries_git_path=/onlykey/libraries

firmware_file=OnlyKey/OnlyKey.ino
firmware_branch=master
libraries_branch=master

#firmware_file=OnlyKey_Beta/OnlyKey_Beta.ino
#firmware_branch=v0.2-beta.8
#libraries_branch=v0.2-beta.8


##this builds the arduino folder
##get arduino-ide
#curl https://downloads.arduino.cc/arduino-1.6.5-r5-linux64.tar.xz -o arduino.tar.xz
##get teensyduino
#curl https://www.pjrc.com/teensy/td_127/teensyduino.64bit -o teensyduino
#tar -xvf arduino.tar.xz
#chmod +x teensyduino
#./teensyduino
##old teensy dont work well, so we get the latest
#cd arduino-1.6.5-r5/hardware/tools
#curl https://www.pjrc.com/teensy/teensy_linux64.tar.gz -o teensy_linux64.tar.gz
#rm ./teensy
#tar -xvf teensy_linux64.tar.gz
#rm teensy_linux64.tar.gz
##because we are headless we dont need to open the flasher so dummy the cmd
#mv teensy_post_compile teensy_post_compile_orig
#touch teensy_post_compile
#chmod +x teensy_post_compile
#cd ../../..


cd /builds
rm -rf /builds/* #clean last build

#get firmware
git clone $firmware_git_path /builds/OnlyKey-Firmware
cd /builds/OnlyKey-Firmware
git checkout $firmware_branch
cd /builds

#get fresh arduino-folder
cp -a /onlykey/arduino-1.6.5-r5 /builds/.

#rename firmware files to be replaced 
cd /builds/arduino-1.6.5-r5/hardware/teensy/avr/cores/teensy3
mv keylayouts.c keylayouts.c_orig
mv keylayouts.h keylayouts.h_orig
mv usb_desc.c usb_desc.c_orig
mv usb_desc.h usb_desc.h_orig
mv usb_dev.c usb_dev.c_orig
mv usb_dev.h usb_dev.h_orig
mv usb_rawhid.c usb_rawhid.c_orig
mv usb_rawhid.h usb_rawhid.h_orig
mv usb_keyboard.c usb_keyboard.c_orig
#gedit usb_keyboard.h someone said to edit keyboard.h but IDK
cd /builds

#copy over custom files
cp /builds/OnlyKey-Firmware/*.c ./arduino-1.6.5-r5/hardware/teensy/avr/cores/teensy3/.
cp /builds/OnlyKey-Firmware/*.h ./arduino-1.6.5-r5/hardware/teensy/avr/cores/teensy3/.

# install custom libraries
cd /builds/arduino-1.6.5-r5/libraries
git init
git remote add origin $libraries_git_path
git pull origin $libraries_branch
cd /builds

cd /builds/arduino-1.6.5-r5
# open ardiono with our firmware
#./arduino ../OnlyKey-Firmware/OnlyKey_Beta/OnlyKey_Beta.ino
/usr/bin/xvfb-run -- ./arduino --verify ../OnlyKey-Firmware/$firmware_file \
  --preferences-file ./preferences.txt 



