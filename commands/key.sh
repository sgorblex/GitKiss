#!/bin/sh

DESCRIPTION="key: manage your ssh public keys"
USAGE="USAGE: key [-h | --help] COMMAND [flags] [arguments]

Where COMMAND is one of:
	ls				lists your active keys
	add <key name>			adds a new key with the specified name
	rm <key name>			deletes the key with the specified name
	rename <key name> <new name>	renames the specified key with the specified new name

OPTIONS:
	-h | --help			shows this help

Maximum number of keys per user is $GK_MAX_KEYS by the current configuration"

set -e

. "$GK_LIB/keys.sh"
. "$GK_LIB/users.sh"


if ! isUser "$GK_USER"; then
	printf "repo: You are not a valid user.\n" >&2
	exit 1
fi

if [ -z "$1" ]; then
	printf "repo: Please specify a command.\n" >&2
	exit 1
fi


key_ls(){
	listKeys "$GK_USER"
}

key_add(){
	if [ -z "$1" ]; then
		printf "key: add: Please specify a new key name.\n" >&2
		exit 1
	fi

	if [ $(keyNumber "$GK_USER") -ge "$GK_MAX_KEYS" ]; then
		printf "key: add: You cannot add any more keys. Maximum number $GK_MAX_KEYS exceeded.\n" >&2
		exit 1
	fi

	if existsKey "$GK_USER" "$1"; then
		printf "key: add: A key named $1 already exists.\n" >&2
		exit 1
	fi

	printf "Insert the public key:\n"
	while true; do
		read key || exit 1
		if isValidKey "$key"; then
			break
		fi
		printf "Invalid key. Insert a valid key:\n" >&2
	done

	addKey "$GK_USER" "$1" "$key"
	printf 'Key "%s" added successfully.\n' "$1"
}

key_rm(){
	if [ -z "$@" ]; then
		printf "key: rm: Please specify a key name.\n" >&2
		exit 1
	fi

	if ! existsKey "$GK_USER" "$1"; then
		printf "key: rm: There is no key named $1.\n" >&2
		exit 1
	fi

	if [ $(keyNumber "$GK_USER") -lt 2 ]; then
		printf "key: rm: You cannot remove your last key!\n" >&2
		exit 1
	fi

	rmKey "$GK_USER" "$1"
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

	if ! existsKey "$GK_USER" "$1"; then
		printf 'key: rename: The key "%s" does not exist.\n' "$1" >&2
		exit 1
	fi

	renameKey "$GK_USER" "$1" "$2"
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
