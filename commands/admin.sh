#!/bin/sh

DESCRIPTION="admin: manage GitKiss admins"
USAGE="USAGE: admin [-h | --help] COMMAND [arguments]

Where COMMAND is one of:
	ls			lists the existing admins
	add [username]		add the specified user to the admins
	rm [admin name]		removes the specified user from the admins

OPTIONS:
	-h | --help		shows this help"

set -e
. $GK_LIB/users.sh

GK_USERS=$GK_CONF/users
GK_ADMINS=$GK_CONF/admins

if ! isOwner $GK_USER; then
	printf "This command can only be run by the server owner.\n"
	exit 1
fi

if [ -z "$1" ]; then
	printf "Please specify a command.\n"
	exit 1
fi


lsAdmin(){
	cat $GK_ADMINS
	printf "\n"
}


addAdmin(){
	if ! isUser $1; then
		printf "$1 is not a valid user.\n"
		exit 1
	elif isAdmin $1; then
		printf "$1 is already an admin.\n"
		exit 1
	fi
	echo $1 >> $GK_ADMINS
}


rmAdmin(){
	if ! isUser $1; then
		printf "$1 is not a valid user.\n"
		exit 1
	elif ! isAdmin $1; then
		printf "$1 is not an admin.\n"
		exit 1
	elif [ $1 = $GK_USER ]; then
		printf "You can't remove yourself (the owner) from the admins."
		exit 1
	fi
	grep $1 $GK_ADMINS > $GK_ADMINS
}


case "$1" in
	"ls")
		lsAdmin
		;;
	"add")
		shift
		addAdmin $@
		;;
	"rm")
		shift
		rmAdmin $@
		;;
	"--help" | "-h")
		printf "%s\n%s\n" "$DESCRIPTION" "$USAGE"
		;;
	*)
		printf "Unrecognised command.\n"
		exit 1
		;;
esac
