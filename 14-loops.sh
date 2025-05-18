#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER=/var/log/shellscript-logs
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

PACKAGES=("mysql" "nginx" "python3" "gcc")

mkdir -p $LOGS_FOLDER
echo "Script started executing at: $(date)" | tee -a "$LOG_FILE"

if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR:: $N Please run this script with root access" | tee -a "$LOG_FILE"
    exit 1 #give other than 0 upto 127
else 
    echo "You are running with root access" &>>$LOG_FILE | tee -a "$LOG_FILE"
fi

# validate functions takes input as exit status, what command they tried to install
VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e "Installing $2 is ... $G SUCCESS $N"  | tee -a "$LOG_FILE"
    else
        echo -e "Installing $2 is ... $R FAILURE $N"  | tee -a "$LOG_FILE"
        exit 1
    fi
}

INSTALL_PACKAGE(){
    dnf list installed $1 &>>$LOG_FILE
    if [ $? -ne 0 ]
    then
        echo "$1 is not installed... going to install it" | tee -a "$LOG_FILE"
        dnf install $1 -y &>>$LOG_FILE
        VALIDATE $? "$1" 
    else
        echo -e "Nothing to do $1 is $Y already installed... $N" | tee -a "$LOG_FILE"
    fi
}

for package in ${PACKAGES[@]}
do
 INSTALL_PACKAGE $package
done

