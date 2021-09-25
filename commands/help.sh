#!/bin/sh

. $GK_LIB/isAdmin.sh
. $GK_LIB/isOwner.sh

printf "Available commands for user $GK_USER:\n"

if isOwner $GK_USER; then
	printf "\n"
	printf "OWNER COMMANDS:\n"
	printf "admin:\tmanage admins\n"
fi

if isAdmin $GK_USER; then
	printf "\n"
	printf "ADMIN COMMANDS:\n"
	printf "user:\tmanage users\n"
fi



printf "\n"
printf "repo:\tmanage repos\n"
