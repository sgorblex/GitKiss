#!/bin/sh

DESCRIPTION="user: manage GitKiss users"
USAGE="USAGE: user [-h | --help] COMMAND [arguments]

Where COMMAND is one of:
	ls			lists the existing users
	new [username]		creates a new user with the specified name to the users
	rm [username]		removes the specified user and their repos from the server

OPTIONS:
	-h | --help		shows this help"

set -e
. $GK_LIB/users.sh
. $GK_LIB/pubKeys.sh

GK_USERS=$GK_CONF/users
GK_ADMINS=$GK_CONF/admins

if ! isAdmin $GK_USER; then
	printf "user: This command can only be run by a server admin.\n" >&2
	exit 1
fi

if [ -z "$1" ]; then
	printf "user: Please specify a command.\n" >&2
	exit 1
fi


lsUser(){
	cat $GK_USERS
	printf "\n"
}


newUser(){
	if isUser $1; then
		printf "user: username $1 already taken.\n" >&2
		exit 1
	fi

	printf "Insert $1's key here:\n"
	while true; do
		read key
		if isValidKey "$key"; then
			break
		fi
		printf "Invalid key. Insert a valid key:\n" >&2
	done
	printf 'no-port-forwarding,no-X11-forwarding,no-agent-forwarding,environment="GK_USER=%s" %s' $1 "$key" >> $GK_AUTHORIZED_KEYS
	if ! ssh-keygen -lf $GK_AUTHORIZED_KEYS > /dev/null; then
		printf "\nAn error occurred. Are you sure the key was valid?\n" >&2
		sed -i '$ d' $GK_AUTHORIZED_KEYS
		exit 1
	fi
	printf "\n$1" >> $GK_CONF/users
	mkdir $GK_REPO_PATH/$1
	printf "User $1 has been added.\n"
}


rmUser(){
	if ! isUser $1; then
		printf "user: $1 is not a valid user.\n" >&2
		exit 1
	elif isAdmin $1; then
		printf "user: you cannot remove an admin.\n" >&2
		exit 1
	fi
	if [ -n $GK_ARCHIVE_PATH ]; then
		printf "WARNING: this will delete the user as well as archive all their repos. Are you sure? (yes/no)"
	else
		printf "WARNING: this will delete the user as well as all their repos. Are you sure? (yes/no)"
	fi
	read ans
	if [ "$ans" != "yes" ]; then
		printf "Operation canceled\n" >&2
		exit 0
	fi

	if [ -n $GK_ARCHIVE_PATH ]; then
		mkdir -p $GK_ARCHIVE_PATH
		mv $GK_REPO_PATH/$1 $GK_ARCHIVE_PATH/
	else
		rm -rf $GK_REPO_PATH/$1
	fi
	sed -i "/$1/d" $GK_USERS
	sed -i "/\"GK_USER=$1\"/d" $GK_AUTHORIZED_KEYS
	printf "$1 has been removed from the users.\n"
}


case "$1" in
	"ls")
		lsUser
		;;
	"new")
		shift
		newUser $@
		;;
	"rm")
		shift
		rmUser $@
		;;
	"--help" | "-h")
		printf "%s\n%s\n" "$DESCRIPTION" "$USAGE"
		;;
	*)
		printf "user: Unrecognised command.\n" >&2
		exit 1
		;;
esac