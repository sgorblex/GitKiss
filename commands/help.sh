#!/bin/sh

. $GK_LIB/isAdmin.sh
. $GK_LIB/isOwner.sh

printf "\nAvailable commands for user $GK_USER:\n\n"

if isOwner $GK_USER; then
	printf "OWNER COMMANDS:\n"
	printf "admin:\tmanage admins\n"
fi

if isAdmin $GK_USER; then
	printf "ADMIN COMMANDS:\n"
	printf "user:\tmanage users\n"
	printf "\n"
fi
