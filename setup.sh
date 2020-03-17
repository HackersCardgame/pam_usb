#!/bin/bash

#Script Template
#==============================================================================
#title           :
#description     :
#author		 :Marc Landolt, @FailDef
#date            :
#version         :0.1
#usage		 :
#notes           :
#bash_version    :
#==============================================================================


# Define Editor
#==============================================================================
#EDITOR=$(which nano)
EDITOR=$(which vim)
#==============================================================================


# Color Definitions
#==============================================================================
red="\e[91m"
default="\e[39m"
#==============================================================================


# Define which Linux Distribution
#==============================================================================
#distro=jessie
#distro=stretch
distro=buster
#==============================================================================

# Define ipv4 for Apt
ip="-o Acquire::ForceIPv4=true"

# Helper Function to show first the command that is beeing executed
#==============================================================================
function ShowAndExecute {
#show command
echo ================================================================================
echo -e "${red} $1 ${default}"
echo --------------------------------------------------------------------------------
#execute command
sudo $1
#test if it worked or give an ERROR Message in red, return code of apt is stored in $?
rc=$?;
if [[ $rc != 0 ]]
  then
	  echo -e ${red}ERROR${default} $rc
	  echo $1 >>fail.txt
fi
}
##test if everything worked
#==============================================================================


# Helper Function for YES or NO Answers
#------------------------------------------------------------------------------
# Example YESNO "Question to ask" "command to be executed"
#==============================================================================
function YESNO {
echo -e -n "
${red}$1 [y/N]${default} "
read -d'' -s -n1 answer
echo
if  [ "$answer" = "y" ] || [ "$answer" = "Y" ]
then
return 0
else
echo -e "
"
return 1
fi
}
#==============================================================================


# Test if script runs as root otherweise exit with exit code 1
#==============================================================================
#if [[ $EUID -ne 0 ]]; then
#  echo -e -n "
#${red}You must be a root user to run this script${default}
#at the moment you are " 2>&1
#  id | cut -d " " -f1
#  echo
#  exit 1
#fi
#==============================================================================


# Test if user has given enough parameters
#==============================================================================
if "$1" = ""
then
echo -e "
Usage:
------
Enter the (new) Database Password as parameter ${red}sudo ${0} 123456${default} "
echo
echo " arguments ---------------->  ${@}     "
echo " \$1 ----------------------->  $1       "
echo " \$2 ----------------------->  $2       "
echo " path to script ----------->  ${0}     "
echo " parent path -------------->  ${0%/*}  "
echo " script name -------------->  ${0##*/} "
echo
exit 0
fi
#==============================================================================

echo -e "${red}${0} ${@}${default}"
echo ""

# add device
#==============================================================================
echo -e in another terminal window type ${red}pamusb-conf --add-device /dev/sdbX${default}
echo "(where /dev/sdbX is the device you want to use as token)"
echo ""

# add user
echo -e in another terminal winoww type ${red}pamusb-conf --add-user $USER${default}
echo "(or if you would like to have another user to use this token specify that user)"

# copy common-auth
#==============================================================================
if YESNO "would you like to copy the preconfigured common-auth to /etc/pam.d/?"
then
ShowAndExecute "cp ./common-auth /etc/pam.d/"
fi


# edit common-auth
#==============================================================================
if YESNO "Edit /etc/pam.d/common-auth?"
then
sudo $EDITOR /etc/pam.d/common-auth -c ":18"
fi

echo open an new terminal and test if you can do sudo su, otherwise change
echo "the line with pam_usb.so to disabled with a # before you loose the"
echo root privilige here in this terminal
