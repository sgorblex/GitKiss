#!/bin/sh

DESCRIPTION="user: manage GitKiss users"
USAGE="USAGE: user [-h | --help] COMMAND [arguments]

Where COMMAND is one of:
	ls			lists the existing users
	new <username>		creates a new user with the specified name to the users
	rm <username>		removes the specified user and their repos from the server

OPTIONS:
	-h | --help		shows this help

Maximum number of server users is $GK_MAX_USERS by the current configuration"

set -e

. "$GK_LIB/keys.sh"
. "$GK_LIB/users.sh"


if ! isAdmin "$GK_USER"; then
	printf "user: This command can only be run by a server admin.\n" >&2
	exit 1
fi

if [ -z "$1" ]; then
	printf "user: Please specify a command.\n" >&2
	exit 1
fi


user_ls(){
	listUsers
}


user_new(){
	if isUser "$1"; then
		printf "user: username $1 already taken.\n" >&2
		exit 1
	fi

	if ! isValidUserName "$1"; then
		printf "user: invalid username: $1.\n" >&2
		exit 1
	fi

	if [ $(userNumber) -ge "$GK_MAX_USERS" ]; then
		printf "user: new: You cannot create any more users. Maximum number $GK_MAX_USERS exceeded.\n" >&2
		exit 1
	fi

	printf "Insert $1's public key here:\n"
	while true; do
		read key || exit 1
		if isValidKey "$key"; then
			break
		fi
		printf "Invalid key. Insert a valid key:\n" >&2
	done

	newUser "$1" "$key"
	printf "User $1 has been added.\n"
}


user_rm(){
	if ! isUser "$1"; then
		printf "user: $1 is not a valid user.\n" >&2
		exit 1
	elif isAdmin "$1"; then
		printf "user: you cannot remove an admin.\n" >&2
		exit 1
	fi
	if [ -n "$GK_ARCHIVE_PATH" ]; then
		printf "WARNING: this will delete the user as well as archive all their repos. Are you sure? (yes/no)\n"
	else
		printf "WARNING: this will delete the user as well as all of their repos. Are you sure? (yes/no)\n"
	fi
	read ans
	if [ "$ans" != "yes" ]; then
		printf "Operation canceled\n" >&2
		exit 0
	fi

	rmUser "$1"
	printf "$1 has been removed from the users.\n"
}


case "$1" in
	"ls")
		user_ls
		;;
	"new")
		shift
		user_new $@
		;;
	"rm")
		shift
		user_rm $@
		;;
	"--help" | "-h")
		printf "%s\n%s\n" "$DESCRIPTION" "$USAGE"
		;;
	*)
		printf "user: Unrecognised command.\n" >&2
		exit 1
		;;
esac
