#!/bin/sh

. $GK_LIB/isAdmin.sh

printf "\nAvailable commands for user $GK_USER:\n\n"

if isAdmin $GK_USER; then
	printf "ADMIN COMMANDS:\n"
	printf "user:\tmanage users\n"
	printf "\n"
fi
