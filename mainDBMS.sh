#!/bin/bash 
shopt -s extglob
export LC_COLLATE=C


#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#----------------------inital start------------------------#
#create data bases container if it is not exit
if [ -d .data_bases ]
	then
	echo -n ""
else
    echo -n ""
	mkdir ./.data_bases
fi
#----------------------------------------------------------#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#


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
function successful_icon
{
	echo -e "$Green$1 ✅ $ENDCOLOR"
}

function fail_icon
{
	echo -e "$Red$1 ⛔ $ENDCOLOR"
}

function warning_icon
{
	echo -e "$Yellow$1 ⚠️ $ENDCOLOR"
}


function info_icon
{
	echo -e "$Blue$1 ℹ️ $ENDCOLOR"
}

#----------------------------------------------------------#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#


#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#-------------------back bone functions--------------------#
function Regex_correct {
	if [[ $1 =~ ^[A-Za-z][A-Za-z0-9_]*$ ]] # ^[0-9a-zA-Z_]+$  ^[A-Za-z]+$
	then
		return 0
	else    
        echo "$1"
		fail_icon "Invalid name"
		info_icon "Database names can't be empty or cantaining spaces or special characters and not starting with numbers"
		return 1 
	fi
}

function w8_clear {
    sleep 0.7
    echo -n "..."
    sleep 0.7
    echo -n "..."
    sleep 0.7
    clear
}

#----------------------------------------------------------#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#


#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#-------------------DataBase functions---------------------#

function Create_DataBase(){
    echo "Avilable Databases are: " 
    ls ./.data_bases
    read -p "Enter Database Name you want to create : " DBname
    if  Regex_correct "$DBname" ; then

        if [ -d ./.data_bases/$DBname ]; then
		    fail_icon "DB with the name $DBname already exists"
            echo " please re-enter a new name.."
            main_Menu
            

        else

            mkdir ./.data_bases/$DBname 2>>./.error.log
            w8_clear
            successful_icon "new Database named $DBname has been successfuly created"
            main_Menu
        fi
    
    
    else
        main_Menu
    fi
}

function Rename_Databases {
    if [ -z "$(ls -A ./.data_bases)" ]; then

        warning_icon "there is no databases to rename"
        main_Menu

    else
        echo "Avilable Databases are: " 
        ls ./.data_bases
        read -p "Enter Database Name you want to rename it  : " old_DBname

        if  Regex_correct "$old_DBname" ; then

         x=`ls ./.data_bases | grep "$old_DBname"` 

            if [ $? -eq 0 ] ; then
                read -p "Enter the new Database name : " new_DBname

                if Regex_correct "$new_DBname" ; then

                    if [ -d ./.data_bases/$new_DBname ] ; then
                        w8_clear
                     	fail_icon "DB with the same name $new_DBname already exists"
                        echo " please re-enter a new name.."
                        Rename_Databases


                    else
                        w8_clear
                        mv ./.data_bases/$old_DBname ./.data_bases/$new_DBname
                        successful_icon "the $new_DBname has been successfuly renamed to $old_DBname"
                        main_Menu

                    fi

                else
                    main_Menu
                fi

            else 
                fail_icon "$old_Name does not exist please try again"

            fi

        else
            main_Menu
        fi

    fi

}

function Drop_Databases {
    if [ -z "$(ls -A ./.data_bases)" ]; then

        warning_icon "there is no databases to drop"
        main_Menu

    else
        echo "Avilable Databases are: " 
        ls ./.data_bases
        read -p "Enter Database Name you want to Drop it  : " DBname


        if [ -d ./.data_bases/$DBname ] ; then

           warning_icon "Are you sure you want to drop $DBname"

           select user_input in 'y' 'n'
            do
                case $user_input in
                    'y' )  

                      rm -r ./.data_bases/$DBname
                      w8_clear
                      successful_icon "$DBname was dropped successfully"
                      main_Menu
                      break
                    ;;
                    'n' )  
                      Drop_Databases     
                      break
                    ;;
                   * )  warning_icon "Choose a Valid Option"
                    ;;
                esac
            done 

        else
            fail_icon "$DBname Doesn't exist!"
            Drop_Databases
            main_Menu
        fi
    fi

}

function Connect_DataBase {

    if [ -z "$(ls -A ./.data_bases)" ]; then

        warning_icon "there is no databases to connect to"
        main_Menu

    else
        echo "Avilable Databases are: " 
        ls ./.data_bases
        read -p "Enter Database Name you want to select : " DBname


        if [ $? -eq 0 ]; then
            cd ./.data_bases/$DBname
            successful_icon "Database $DBname was Successfully Selected"
            tables_Menu
        else
            fail_icon "Database $DBname not existed"
            main_Menu
        fi
    
    fi
  
}
#----------------------------------------------------------#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#




#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#--------------------Tables functions----------------------#

function Drop_Table {
    if [ -z "$(ls -A )" ]; then

        warning_icon "there is no Tables to drop"
        tables_Menu

    else
        echo "Avilable Tabels are: " 
        ls ./$DBname
        read -p "Enter Database Name you want to Drop it  : " DBname


        if [ -d ./.data_bases/$DBname ] ; then

           warning_icon "Are you sure you want to drop $DBname"

           select user_input in 'y' 'n'
            do
                case $user_input in
                    'y' )  

                      rm -r ./.data_bases/$DBname
                      w8_clear
                      successful_icon "$DBname was dropped successfully"
                      main_Menu
                      break
                    ;;
                    'n' )  
                      Drop_Databases     
                      break
                    ;;
                   * )  warning_icon "Choose a Valid Option"
                    ;;
                esac
            done 

        else
            fail_icon "$DBname Doesn't exist!"
            Drop_Databases
            main_Menu
        fi
    fi

}




#----------------------------------------------------------#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#




function tables_Menu() {
echo "   _____________________[Tables_Menu]____________________  "
echo "  /                                                      \ "
echo "  @   1. Create New Table                                @ "
echo "  @   2. Show Existing Tables                            @ "
echo "  @   3. Drop Table                                      @ "
echo "  @   4. Select From Table                               @ "
echo "  @   5. Insert Into Table                               @ "
echo "  @   5. Update From Table                               @ "
echo "  @   6. Delete From Table                               @ "
echo "  @   7. Back to the main menu                           @ "
echo "  @   8. Exit                                            @ "
echo "  \______________________________________________________/ "
  
  echo  
  read -p "Select option: "  user_input
  
  case $user_input in
    1 )  Create_Table ;;
    2 )  ls ; tables_Menu;;
    3 )  Drop_Table ;;
    4 )  Rename_Databases ;;
    5 )  Drop_Databases ;;
    6 )  exit ;;
    * )  warning_icon "Please select valid pick" ; tables_Menu ;
  esac

}





function main_Menu() {
echo "   _____________________[Main Menu]______________________  "
echo "  /                                                      \ "
echo "  @   Hey, Welcome To DBMS using bash script,            @ "
echo "  @   this is the Main Menu... pleas select one of       @ "
echo "  @   the options below.                                 @ "
echo "  @                                                      @ "
echo "  @   1. Create Database                                 @ "
echo "  @   2. Lsit Databases                                  @ "
echo "  @   3. Select Databases                                @ "
echo "  @   4. Rename Databases                                @ "
echo "  @   5. Drop Databases                                  @ "
echo "  @   6. Exit                                            @ "
echo "  \______________________________________________________/ "
  
  echo  
  read -p "Select option: "  user_input
  
  case $user_input in
    1 )  Create_DataBase ;;
    2 )  ls ./.data_bases ; main_Menu;;
    3 )  Connect_DataBase ;;
    4 )  Rename_Databases ;;
    5 )  Drop_Databases ;;
    6 )  exit ;;
    * )  warning_icon "Please select valid pick" ; main_Menu ;
  esac

}
main_Menu
