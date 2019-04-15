#!/usr/bin/env bash

# Small program that sets up the phidgets on the Raspberry Pi
# Author: Heiko van der Heijden

# Global variable for no color
NC='\033[0m' 

# Prints something in green.
# Useful for showing info
function printInfo {
    GREEN='\033[1;32m'
    echo -e "${GREEN}$1${NC}"
}

function printError {
    RED='\033[1;31m'
    echo -e "${RED}$1${NC}"
}

# Checking if we have root privilges.
# otherwise it will not be possible to install the Phidgets
if [ "$EUID" -ne 0 ]
then 
    printError "Please run as root"
    exit
fi

printInfo "Moving to the tmp directory"
mkdir /tmp/phidgetinstaller
cd /tmp/phidgetinstaller

# Make sure we have an updated system
printInfo "updating system, before starting the installation"
apt update -y
apt upgrade -y

# install preliminary dependencies
printInfo "Installing the first dependencies (libusb, zip and unzip)"
apt install -y libusb-1.0-0-dev zip unzip 

# Add repository for phidgets
printInfo "Adding phidgets to the repo"
wget -qO- http://www.phidgets.com/gpgkey/pubring.gpg | apt-key add -
echo 'deb http://www.phidgets.com/debian stretch main' > /etc/apt/sources.list.d/phidgets.list
apt update -y

printInfo "installing libphidget22 and dev"
apt install -y libphidget22 libphidget22-dev

printInfo "Downloading the python libraries "
wget https://www.phidgets.com/downloads/phidget22/libraries/any/Phidget22Python.zip
unzip Phidget22Python
cd Phidget22Python

printInfo "Installing python3 libraries"
python3 setup.py install

printInfo "Cleaning up"
cd ..
rm -rf Phidget22Python
rm -rf Phidget22Python.zip

printInfo "Downloading example"
wget https://www.phidgets.com/downloads/phidget22/examples/python/VoltageInput/Phidget22_VoltageInput_Python_Ex.zip

# placing the example files on the desktop
unzip Phidget22_VoltageInput_Python_Ex.zip
mkdir /home/pi/Desktop/VoltageExample
mv *.py /home/pi/Desktop/VoltageExample
chown pi /home/pi/Desktop/VoltageExample/*.py



