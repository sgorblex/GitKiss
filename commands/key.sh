#!/bin/sh

DESCRIPTION="key: manage your ssh public keys"
USAGE="USAGE: key [-h | --help] COMMAND [flags] [arguments]

Where COMMAND is one of:
	ls				lists your active keys
	add [key name]			adds a new key with the specified name
	rm [key name]			deletes the key with the specified name
	rename [key name] [new name]	renames the specified key with the specified new name

OPTIONS:
	-h | --help		shows this help"

set -e

. $GK_LIB/users.sh
. $GK_LIB/pubKeys.sh

if ! isUser $GK_USER; then
	printf "repo: You are not a valid user.\n" >&2
	exit 1
fi

if [ -z "$1" ]; then
	printf "repo: Please specify a command.\n" >&2
	exit 1
fi


key_ls(){
	sed -n "s/.*\"GK_USER=$GK_USER\".* \(.*\)/\1/p" $GK_AUTHORIZED_KEYS
}

key_add(){
	if [ -z "$@" ]; then
		printf "key: add: Please specify a new key name.\n" >&2
		exit 1
	fi

	
	printf "Insert the public key:\n"
	while true; do
		read key
		if isValidKey "$key"; then
			break
		fi
		printf "Invalid key. Insert a valid key:\n" >&2
	done

	completeKey=$(keyPreamble $GK_USER)$(nameKey "$key" "$1")
	printf "$completeKey\n" >> $GK_AUTHORIZED_KEYS
	if ! ssh-keygen -lf $GK_AUTHORIZED_KEYS &> /dev/null; then
		printf "\nAn error occurred. Are you sure the key was valid?\n" >&2
		sed -i '$ d' $GK_AUTHORIZED_KEYS
		exit 1
	fi

	printf 'Key "%s" added successfully.\n' $1
}

key_rm(){
	if [ -z "$@" ]; then
		printf "key: rm: Please specify a key name.\n" >&2
		exit 1
	fi

	if [ $(grep -E "^$(keyPreamble $GK_USER)" $GK_AUTHORIZED_KEYS | wc -l) -lt 2 ]; then
		printf "You cannot remove your last key!" >&2
		exit 1
	fi

	sed -i "/\"GK_USER=$GK_USER\".* $@/d" $GK_AUTHORIZED_KEYS
	printf "$1 has been removed from your keys.\n"
}

key_rename(){
	if [ -z "$1" ]; then
		printf "key: rename: Please specify a key name.\n" >&2
		exit 1
	fi
	if [ -z "$2" ]; then
		printf "key: rename: Please specify a new key name.\n" >&2
		exit 1
	fi

	if ! existsKey $GK_USER $1; then
		printf 'key: rename: The key "%s" does not exist.\n' $1 >&2
		exit 1
	fi

	sed -i "s/\(.*\"GK_USER=$GK_USER\".* \)$1/\1$2/" $GK_AUTHORIZED_KEYS
	printf "$1 has been renamed to $2.\n"
}


case "$1" in
	"ls")
		key_ls $@
		;;
	"add")
		shift
		key_add $@
		;;
	"rm")
		shift
		key_rm $@
		;;
	"rename")
		shift
		key_rename $@
		;;
	"--help" | "-h")
		printf "%s\n%s\n" "$DESCRIPTION" "$USAGE"
		;;
	*)
		printf "Unrecognised command.\n" >&2
		exit 1
		;;
esac
