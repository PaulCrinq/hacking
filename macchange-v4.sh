#!/bin/bash
#===============|< > with <3 by Badcode|===============
# written the 7th of april 2019
# I hope you enjoy this module and find it usefull !
# before running this script, make sure you have macchanger installed, it will install itself if you are on a Debian system
# but if you are on a CentOS-based system, you will have to do it manually, to do so, run "yum install macchanger", enjoy :)
RED='\033[0;31m' # red
YELLOW='\033[1;33m' # yellow
NC='\033[0m' # No Color
POWDERBLUE=$(tput setaf 153) # a quite cool blue
UNDL=$(tput smul) # underlined
BLINK=$(tput blink) # probably blinks
CurentTime=$(date +%H) # current time (hours only)
MCinstalled=$(dpkg -s macchanger | grep Status) # checking is macchanger is installed on your system
function trap_ctrlc ()		# initiating the function that will catch [CTRL+#C]
{
while true
do
        printf "${RED}CTRL+C detected... do you really want to exit the script ?${POWDERBLUE}[Y/N]${NC}\n"
        read userinput
        case $userinput in
          "Y"|"y")
                printf "${RED}exiting the script...${NC}"
		echo "changing back to persistent MAC..."
		sudo macchanger -p $ifacename
		sleep 0.5
		printf "putting ${RED} $ifacename ${NC} back up..."
		sudo ifconfig $ifacename up
		sleep 2
                exit 2
                ;;
          "N"|"n")
		echo "returning to the script..."
                sleep 2
                return
                ;;
           *)
                printf "${RED}invalid option, please answer with ${B} Y ${RED}or ${B} N${NC}\n"
                sleep 2
                ;;
        esac
done
}
trap "trap_ctrlc" 2
printf "${YELLOW}${BLINK}welcome to macchange !${BLINK} !${NC}\n" 
case $MCinstalled in		# performing a quick check to see if macchanger is installed on your system
	"Status: install ok installed")
		;;
	*) 
		printf "${RED}macchanger is not installed...installing${NC}\n"
		sudo apt-get install macchanger
		printf "${POWDERBLUE}Installed !${NC}\n"
		;;
esac
printf "${POWDERBLUE}---------------------------------------${NC}\n"
sudo ifconfig -s | cut -c1-5
printf "${POWDERBLUE}---------------------------------------${NC}\n"
printf "${POWDERBLUE}select an interface :${NC}\n"
read ifacename
printf "chosen interface : ${RED}$ifacename${NC}\n"
sudo ifconfig $ifacename down							# putting down the interface the user chose to be able to modify the MAC
printf "putting${RED} $ifacename ${NC}down...\n"
sleep 1										# just sleeps lol
printf "${POWDERBLUE}---------------------------------------${NC}\n"
sudo ifconfig $ifacename | grep inet						# just giving you more info about
sudo ifconfig $ifacename | grep ether						# the interface you chose earlier
printf "	interface state : ${RED}down${NC}\n"
printf "${POWDERBLUE}---------------------------------------${NC}\n"
echo what do you want to do ?
echo "1 : randomize MAC address"						#
echo "2 : choose specific MAC adress"						# user option menu
echo "3 : go back to permanent mac"						#
read option
case $option in									#
  "1") 										#
	printf "${POWDERBLUE}chosen option 1 - randomize your mac${NC}\n"	#
        sudo macchanger -r $ifacename						#
	;;									#
  "2")										#
	printf "${POWDERBLUE}chosen option 2 - use a specific mac${NC}\n"	# the following code is just to compare your entry to the coded entries, if you want to add more features
        printf "${POWDERBLUE}which MAC do you want to use ?${NC}\n"		# just add more lines, numbers (entries) and the corresponding commands
        read MACchosen								#
        sudo macchanger -m $MACchosen $ifacename				#
	;;									#
  "3")										#
	printf "${POWDERBLUE}chosen option 3 - return to permanent mac${NC}\n"	#
        sudo macchanger -p $ifacename						#
	;;									#
  *)										#
	printf "${RED}invalid option${NC}\n"					#
esac
sleep 2.5							# disable this if you are not using a launcher
sudo ifconfig $ifacename up							# putting the interface picked earlier back up (wich is pretty usefull)
printf "${RED}$ifacename is back  up ! ${NC}\n"
if [ $CurentTime -lt 6 ] ; then							# performing a time check to adapt the goodbye message to
	printf "${YELLOW}have a good night !${NC}\n"				#
elif [ $CurentTime -gt 6 ] && [ $CurentTime -lt 22 ] ; then			#
	printf "${YELLOW}have a good day !${NC}\n"				#
elif [ $CurentTime -gt 22 ] ; then						#
	printf "${YELLOW}have a good night !${NC}\n"				#
fi
sleep 3								# disable this if you are not using a launcher

