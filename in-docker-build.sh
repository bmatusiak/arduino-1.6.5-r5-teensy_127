#!/bin/bash -xe

# PLEASE NOTE. 
# Most people wont need the ability to compile firmware themselves, 
# as you can't load custom firmware unless you have a developer onlykey.
# Right now you can compile it if you want, but probably not worth your time lol
# 

#https://github.com/trustcrypto/OnlyKey-Firmware/issues/59

####-------   WHERE 
firmware_git_path=https://github.com/trustcrypto/OnlyKey-Firmware
libraries_git_path=https://github.com/trustcrypto/libraries

## `/onlykey/.` is relative to this script
## folders, this script is `/onlykey/in-docker-build.sh`, OnlyKey-Firmware, libraries are .gitignored
#firmware_git_path=/onlykey/OnlyKey-Firmware
#libraries_git_path=/onlykey/libraries


####-------   WHAT   ## you can load any git checkouts or branch
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

#get clean arduino
cp -a /onlykey/arduino-1.6.5-r5 /builds/.

#get firmware
if [[ -d "${firmware_git_path}" && ! -L "${firmware_git_path}" ]] ; then
    cp -a $firmware_git_path /builds/OnlyKey-Firmware
else
    git clone $firmware_git_path /builds/OnlyKey-Firmware
    cd /builds/OnlyKey-Firmware
    git checkout $firmware_branch
    cd /builds
fi

#copy firmware
cp /builds/OnlyKey-Firmware/*.c ./arduino-1.6.5-r5/hardware/teensy/avr/cores/teensy3/.
cp /builds/OnlyKey-Firmware/*.h ./arduino-1.6.5-r5/hardware/teensy/avr/cores/teensy3/.

#copy custom libraries
if [[ -d "${libraries_git_path}" && ! -L "${libraries_git_path}" ]] ; then
    cp -a $libraries_git_path/* /builds/arduino-1.6.5-r5/libraries/.
else
    cd /builds/arduino-1.6.5-r5/libraries
    git init
    git remote add origin $libraries_git_path
    git pull origin $libraries_branch
    cd /builds
fi

cd /builds/arduino-1.6.5-r5
/usr/bin/xvfb-run -- ./arduino --verify ../OnlyKey-Firmware/$firmware_file \
  --preferences-file ./preferences.txt 

cd ../
cp ./build/*.hex .
rm -rf ./arduino-1.6.5-r5
rm -rf ./build
rm -rf ./OnlyKey-Firmware

