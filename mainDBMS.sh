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
            mkdir ./.data_bases/$DBname/.tmptable 2>>./.error.log
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

function Create_Table {
    echo "Avilable tables are: " 

    ls 
    read -p "Enter table name you want to create : " TBName

    wating_for_PK="true"

    if  Regex_correct "$TBName" ; then

        if [ $TBName ];
        then
            if [ -a $TBName ]; 
                then
                fail_icon "Table with name $TBName already exists"    
            else
                touch .tmptable/$TBname
                read -p "Enter the number of coloumns : " COLNumber
                
                 expr $COLNumber + 1 2> /dev/null 

                while [ $? != 0 ]
                do
                    warning_icon "Please enter a valid number"
                    read -p "Enter the number of coloumns : " COLNumber
                    expr $COLNumber + 1 2> /dev/null >> /dev/null

                done

                ## now read colomn type and names
                i=1
                while [ $i -le $COLNumber  ]
                do
                    ## gen name of field
                    read -p "Enter the name of column number $i: " COLName;

                    while [ -z "$COLNumber" ]; do

                        warning_icon "Field name can't be empty";
                        read -p "Enter the name of column number $i: " COLName;

                    done

                    ## check if field is PK or not
                    while [ $wating_for_PK == "true" ]
                    do         
                        echo "is this feild a primary key?"
                        select answer in "y" "n"
                        do
                            case $answer in
                            "y" )
                                echo -n "%P_Key%" >> .tmptable/$TBName
                                wating_for_PK="false"
                                break
                                ;;
                            "n" )
                                break 
                                ;; 
                            * )
                                warning_icon "Please choose a valid option"
                                ;;
                            esac
                        done 
                        break
                    done

                    ## get datatype of field
                    read -p "Enter a valid column $i datatype : [string/int] " data_Type;
                    while [[ "$data_Type" != *(int)*(string) || -z $data_Type ]]
                    do
                        warning_icon "Invalid datatype"
                        read -p "Enter a valid column $i datatype again : [string/int] " data_Type;
                    done

                    ## write in the table file; check to stop adding ":" in the last field
                    if [ $i -eq $COLNumber ]
                        then
                        echo $COLName"%"$data_Type"%" >> .tmptable/$TBName
                    else
                        echo -n $COLName"%"$data_Type"%:" >> .tmptable/$TBName
                    fi

                    ((i=$i+1))

                done
                
                mv .tmptable/$TBName ./$TBName
                w8_clear
                successful_icon "Table created successfully"    
            fi
        else
            fail_icon "invalid input please enter a valid name"
        fi
        tables_Menu
    else
        Create_Table
    fi






}

function Renam_Table {
    if [ -z "$(ls -A )" ]; then

        warning_icon "there is no tables to rename"
        tables_Menu

    else
        echo "Avilable Tables Are: " 
        ls
        read -p "Enter the table name you want to rename it  : " old_TBname

        if  Regex_correct "$old_TBname" ; then

         x=`ls | grep "$old_TBname"` 

            if [ $? -eq 0 ] ; then
                read -p "Enter the new table name : " new_TBname

                if Regex_correct "$new_TBname" ; then

                    if [ -d $new_TBname ] ; then
                        
                     	fail_icon "DB with the same name $new_TBname already exists"
                        echo " please re-enter a new name.."
                        Renam_Table


                    else
                        w8_clear
                        mv $old_TBname $new_TBname
                        successful_icon "the $new_TBname has been successfuly renamed to $old_TBname"
                        tables_Menu

                    fi

                else
                    tables_Menu
                fi

            else 
                fail_icon "$old_Name does not exist please try again"

            fi

        else
            tables_Menu
        fi

    fi

}

function Drop_Table {
    if [ -z "$(ls -A )" ]; then

        warning_icon "there is no Tables to drop"
        tables_Menu

    else
        echo "Avilable Tabels are: " 
        ls 
        read -p "Enter the table Name you want to Drop it  : " TBname
        pwd

        if [ -f $TBname ] ; then

           warning_icon "Are you sure you want to drop the table named $TBname"

           select user_input in 'y' 'n'
            do
                case $user_input in
                    'y' )  

                      rm -r $TBname
                      w8_clear
                      successful_icon "$TBname table was dropped successfully"
                      tables_Menu
                      break
                    ;;
                    'n' )  
                      tables_Menu     
                      break
                    ;;
                   * )  warning_icon "Choose a Valid Option"
                    ;;
                esac
            done 

        else
            fail_icon "$TBname table Doesn't exist!"
            tables_Menu
            
        fi
    fi

}

#----------------------------------------------------------#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#


#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#--------------------Tables functions----------------------#
function checkPkInsert
{
        read -p "enter ($fieldName) of type ($fieldType) : " value
        ############################
        ## check empty
        if [ "$value" ]
        then
            echo "nothin">> /dev/null
            #nothing
        else 
            printWarning "please enter a valid value"
            checkPkInsert
        fi
        
        ###########################
        ## check data type
        if [ $fieldType == "int" ]
            then
            checkInt "$value"
            if [ $? != 0 ]
            then
            warning_icon "please enter a valid value"
            checkPkInsert
            fi
        fi

        ############################
        ## check PK constraint
        checkPK $i "$value"
        if [ $? != 0 ]
        then
            fail_icon "Violation of PK constraint"
            warning_icon "please enter a valid value"
            checkPkInsert
        fi
}

function checkNormalInsert
{
        read -p "enter ($fieldName) of type ($fieldType) : " value
        ############################
        ## check empty
        if [ "$value" ]
        then
            echo "nothin">> /dev/null
            #nothing
        else 
            warning_icon "please enter a valid value"
            checkNormalInsert
        fi
        
        ###########################
        ## check data type
        if [ $fieldType == "int" ]
            then
            checkInt "$value"
            if [ $? != 0 ]
            then
            warning_icon "please enter a valid value"
            checkNormalInsert
            fi
        fi
}

function insertField {
      if [ $i -eq $COLNumber ]
                then
                echo $1 >> $TBName
            else
                echo -n $1":" >> $TBName
      fi
}

function checkInt {
    expr $1 + 1 2> /dev/null >> /dev/null
}

function checkPK {
   if `cut -f$1 -d: $TBName | grep -w $2 >> /dev/null 2>/dev/null`
        then
        return 1
    else
        return 0
    fi 
}

function Insert_Into_Table {

        echo "Avilable tables are: " 
        ls 
        read -p "please enter table name : " TBName

        if [ $TBName ]
        then
            if [ -a $TBName ]
                then
                COLNumber=`awk -F: 'NR==1 {print NF}' $TBName`

                for (( i=1; i <= $COLNumber; i++ ))
                do
                    ##############################
                    ## inserting primary key field
                    if  Test_P_Key=`grep "%:" $TBName | cut -d ":" -f$i | grep "%P_Key%" ` 
                        then 
                        fieldName=`grep "%:" $TBName | cut -d ":" -f$i | cut -d "%" -f3 `
                        fieldType=`grep "%:" $TBName | cut -d ":" -f$i | cut -d "%" -f4 `
                        info_icon "this is primary key it must be uniqe"

                        checkPkInsert
                        insertField "$value"


                    #########################    
                    ## inserting normal field
                    else
                        fieldName=`grep "%:" $TBName | cut -d ":" -f$i | cut -d "%" -f1 `
                        fieldType=`grep "%:" $TBName | cut -d ":" -f$i | cut -d "%" -f2 `

                        checkNormalInsert
                        insertField "$value"
                    fi
                done
            else
                fail_icon "Table $tableName doesn't exist"
            fi
        else
            fail_icon "Invalid input please enter a valid name"
        fi

}



#----------------------------------------------------------#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#


function tables_Menu() {
echo "   ________________[Tables creation Menu]________________   "
echo "  /                                                      \  "
echo "  @   1->  Show Existing Tables                           @ "
echo "  @   2->  Create New Table                               @ "
echo "  @   3->  Rename Tables                                  @ "
echo "  @   4->  Drop Table                                     @ "
echo "  @   5->  Insert Into Table                              @ "
echo "  @   6->  Select From Table                              @ "
echo "  @   7->  Update From Table                              @ "
echo "  @   8->  Delete From Table                              @ "
echo "  @   9->  Back to the main menu                          @ "
echo "  @   10-> Exit                                           @ "
echo "  \______________________________________________________/  "
  
  echo  
  read -p "Select option: "  user_input
  
  case $user_input in
    1 )  ls ; tables_Menu;;
    2 )  Create_Table ;;
    3 )  Renam_Table ;;
    4 )  Drop_Table ;;
    5 )  Insert_Into_Table ;;
    6 )  Select_From_Table ;;
    7 )  Update_From_Table ;;
    8 )  Delete_From_Table ;;
    9 )  main_Menu ;;
    10 )  exit ;;
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
echo "  @   1-> Create Database                                @ "
echo "  @   2-> Lsit Databases                                 @ "
echo "  @   3-> Select Databases                               @ "
echo "  @   4-> Rename Databases                               @ "
echo "  @   5-> Drop Databases                                 @ "
echo "  @   6-> Exit                                           @ "
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
