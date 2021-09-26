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
	printf "admin: This command can only be run by the server owner.\n" >&2
	exit 1
fi

if [ -z "$1" ]; then
	printf "admin: Please specify a command.\n" >&2
	exit 1
fi


lsAdmin(){
	cat $GK_ADMINS
}


addAdmin(){
	if ! isUser $1; then
		printf "admin: $1 is not a valid user.\n" >&2
		exit 1
	elif isAdmin $1; then
		printf "admin: $1 is already an admin.\n" >&2
		exit 1
	fi
	printf "$1\n" >> $GK_ADMINS
	printf "$1 is now an admin.\n"
}


rmAdmin(){
	if ! isUser $1; then
		printf "admin: $1 is not a valid user.\n" >&2
		exit 1
	elif ! isAdmin $1; then
		printf "admin: $1 is not an admin.\n" >&2
		exit 1
	elif [ $1 = $GK_USER ]; then
		printf "admin: You can't remove yourself (the owner) from the admins." >&2
		exit 1
	fi
	sed -i "/$1/d" $GK_ADMINS
	printf "$1 has been removed from the admins.\n"
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
		printf "admin: Unrecognised command.\n" >&2
		exit 1
		;;
esac
