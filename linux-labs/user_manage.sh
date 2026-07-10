#!/bin/bash

if [ "$EUID" -ne 0 ]
then
	echo "Please run this script as root."
	exit 1
fi

echo "Enter group name:"
read GROUP

echo "Enter username:"
read USER

echo "Enter Password:"
read -s PASS

if getent group "$GROUP" >/dev/null
then
	echo "Error: Group already exists."
	exit 1
fi

if id "$USER" >/dev/null 2>&1
then
	echo "Error: User already exists."
	exit 1
fi

groupadd $GROUP

if [ $? -ne 0 ]
then
	echo "Failed to create group."
	exit 1
fi

useradd -m -s /bin/bash -g "$GROUP" "$USER"

if [ $? -ne 0 ]
then
	echo "Failed to create user."

	groupdel "$GROUP"

	exit 1
fi

echo "$USER:$PASS" | chpasswd

if [ $? -ne 0 ]
then
	echo "Error: Failed to set password."

	userdel -r "$USER"
	groupdel "$GROUP"

	exit 1
fi

mkdir "/$USER"

if [ $? -ne 0 ]
then
	echo "Error: Failed to create directory."

	userdel -r "$USER"
	groupdel "$GROUP"

	exit 1
fi

chown "$USER:$GROUP" "/$USER"

chmod 770 "/$USER"

chmod +t "/$USER"

echo
echo "==========================="
echo "User created successfully."
echo "Username : $USER"
echo "Group    : $GROUP"
echo "Directory: /$USER"
echo "===========================" 
