#!/bin/bash
shopt -s extglob
export LC_COLLATE=C

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#---------------------icons functions----------------------#
Red="\e[31m"
Green="\e[32m"
Yellow="\e[0;33m"
ENDCOLOR="\e[0m"
Blue="\e[34m"
bold="\033[1m"
normal="\033[0m"
#----------------------------------------------------------#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#


#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#---------------------icons functions----------------------#

function warning_icon
{
	echo -e "$Yellow$1 ⚠️$ENDCOLOR"
}

function successful_icon
{
	echo -e "$Green$1 ✅$ENDCOLOR"
}

function fail_icon
{
	echo -e "$Red$1 ⛔$ENDCOLOR"
}

function info_icon
{
	echo -e "$Blue$1 ℹ️$ENDCOLOR"
}
#----------------------------------------------------------#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#


#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#-------------------back bone functions--------------------#
function Regex_correct
{
	if [[ $1 =~ ^[a-zA-Z_]+$ ]] # ^[0-9a-zA-Z_]+$  ^[A-Za-z]+$
	then
		return 0
	else    
        echo "$1"
		fail_icon "Invalid name"
		info_icon "Database names can't be \"empty\" or cantaining spaces or special characters"
		return 1 
	fi
}

function w8_clear
{
sleep .7
echo -n "..."
sleep .7
echo -n "..."
sleep .7
clear
}

#----------------------------------------------------------#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#


#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#-------------------DataBase functions---------------------#

function Create_DataBase(){
read -p "Enter Database Name: " DBname
    if  Regex_correct "$DBname" ; then

        if [ -d ./data_bases/$DBname ]; then
		    fail_icon "DB with the name $DBname already exists"
            echo " please re-enter a new name.."
            main_Menu
            

        else

            mkdir ./data_bases/$DBname
            w8_clear
            successful_icon "new Database named $DBname has been successfuly created"
            main_Menu
        fi
    
    
    else
        main_Menu
    fi
}

function Select_DataBase {
read -p "Enter Database Name: " DBname
  cd ./data_bases/$DBname 2>>./.error.log
  if [[ $? == 0 ]]; then
    echo "Database $DBname was Successfully Selected"
    tablesMenu
  else
    echo "There is no Database called $DBname"
    mainMenu
  fi
}














#----------------------------------------------------------#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#









function main_Menu() {
echo "   _____________________[Main Menu]______________________  "
echo "  /                                                      \ "
echo "  @   Hey, Welcome To DBMS using bash script,            @ "
echo "  @   this is the Main Menu... pleas select one of       @ "
echo "  @   the options below.                                 @ "
echo "  @                                                      @ "
echo "  @   1. Create Database                                 @ "
echo "  @   2. lsit Databases                                  @ "
echo "  @   3. Select Databases                                @ "
echo "  @   4. Rename Databases                                @ "
echo "  @   5. Drop Databases                                  @ "
echo "  @   6. Exit                                            @ "
echo "  \______________________________________________________/ "
  
  echo  
  read -p "Select option: "  user_input
  
  case $user_input in
    1 )  Create_DataBase ;;
    2 )  ls -l ./data_bases ; main_Menu;;
    3 )  Select_DataBase ;;
    4 )  rename_DB ;;
    5 )  drop_DB ;;
    6 )  exit ;;
    * )  warning_icon "Please select valid pick" ; main_Menu ;
  esac

}
main_Menu

