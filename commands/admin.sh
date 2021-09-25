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
. $GK_LIB/isOwner


if ! isOwner $GK_USER; then
	printf "This command can only be run by the server owner.\n"
	exit 1
fi

if [ -z "$1" ]; then
	printf "Please specify a command.\n"
	exit 1
fi


lsAdmin(){
	cat $GK_CONF/admins
	printf "\n"
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
