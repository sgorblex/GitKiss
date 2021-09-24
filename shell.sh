#!/bin/sh

set -e

export GK_PATH=${0%/*}
export GK_CONF=$GK_PATH/conf
export GK_COMMANDS=$GK_PATH/commands
export GK_LIB=$GK_PATH/lib
. $GK_CONF/conf

mkdir -p $GK_REPO_PATH

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


if [ "$1" != "-c" ]; then
	printf "\nHi, $GK_USER!\n\n"
	if [ "$GK_INTERACTIVE" = "true" ]; then
		interactive
	else
		printf "You have successfully authenticated, but we don't provide interactive shell access.\n\n"
	fi
	exit 0
fi

shift

# filter out here git pull/push/clone commands

launchCommand $1
