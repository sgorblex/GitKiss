#!/bin/sh

set -e

export GK_PATH=${0%/*}
export GK_CONF=$GK_PATH/conf
export GK_COMMANDS=$GK_PATH/commands
export GK_LIB=$GK_PATH/lib
. $GK_CONF/conf

mkdir -p $GK_REPO_PATH

. $GK_LIB/perms.sh

if [ -z $GK_USER ]; then
	printf "This shell is supposed to be executed via ssh only. You appear to not have any GitKiss username\n" >&2
	exit 1
fi


# launchCommand takes only one string containing the entire command and, if it is valid, it executes it.
launchCommand() {
	cmd=$1
	shift
	args=$@

	if [ -f "$GK_COMMANDS/$cmd.sh" ]; then
		$GK_COMMANDS/$cmd.sh $args
	else
		printf "Unrecognized command.\n" >&2
		return 1
	fi
}


# interactive runs the interactive shell.
interactive(){
	printf "$GK_PROMPT"
	while read line; do
		if [ -z "$line" ]; then
			printf "$GK_PROMPT"
			continue
		fi
		if [ "$line" = "exit" ]; then
			break
		fi
		if ! launchCommand $line; then
			printf "$GK_ERR_PROMPT"
		else
			printf "$GK_PROMPT"
		fi
	done
	printf "exiting...\n" >&2
}

handleGit(){
	if [ $1 != "git" ]; then
		return 0
	fi

	if [ "$3" = "${3##*/}" ]; then
		repo="$GK_USER/$3"
	else
		repo="$3"
	fi

	case $2 in
		"receive-pack")
			if [ $(getPerms $repo $GK_USER) -ne 2 ]; then
				return 1
			else
				$1 $2 $repo
			fi
			;;
		"upload-pack"|"upload-archive")
			if [ $(getPerms $repo $GK_USER) -lt 1 ]; then
				return 1
			else
				$1 $2 $repo
			fi
			;;
		*)
			return 0
	esac

}


if [ "$1" != "-c" ]; then
	printf "Hi, $GK_USER!\n"
	if [ "$GK_INTERACTIVE" = "true" ]; then
		interactive
	else
		printf "You have successfully authenticated, but we don't provide interactive shell access.\n"
	fi
	exit 0
fi

shift


handleGit $1
launchCommand $1
