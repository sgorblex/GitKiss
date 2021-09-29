#!/bin/sh

set -e

GK_PATH="${0%/*}"
GK_CONF="$GK_PATH/conf.sh"
GK_COMMANDS="$GK_PATH/commands"
GK_LIB="$GK_PATH/lib"
. "$GK_LIB/conf.sh"

. "$GK_LIB/perms.sh"

if [ -z "$GK_USER" ]; then
	printf "This shell is supposed to be executed via ssh only. You appear to not have any GitKiss username\n" >&2
	exit 1
fi


launchCommand() {
	cmd="$1"
	shift
	args="$@"

	if [ -f "$GK_COMMANDS/$cmd.sh" ]; then
		"$GK_COMMANDS/$cmd.sh" $args
	else
		printf "Unrecognized command: $cmd\n" >&2
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
	if [ "$1" = "${1#git-}" ]; then
		return 1
	fi

	repo="${2#\'}"		# 'repo' -> repo'
	repo="${repo%\'}"	#  repo' -> repo
	if [ "$repo" = "${repo##*/}" ]; then
		repo="$GK_USER/$repo"
	fi

	case $1 in
		"git-receive-pack")
			if [ $(getPerms "$repo" "$GK_USER") -lt 2 ]; then
				exit 1
			else
				"$1" "$GK_REPO_PATH/$repo.git"
				return 0
			fi
			;;
		"git-upload-pack"|"git-upload-archive")
			if [ $(getPerms "$repo" "$GK_USER") -lt 1 ]; then
				exit 1
			else
				"$1" "$GK_REPO_PATH/$repo.git"
				return 0
			fi
			;;
		*)
			return 1
	esac

}


if [ "$1" = "-c" ]; then
	shift
	handleGit $1 ||	launchCommand $1
else
	printf "$GK_MOTD\n"
	printf "Hi, $GK_USER!\n"
	if [ "$GK_INTERACTIVE" = "true" ]; then
		interactive
	else
		printf "You have successfully authenticated, but we don't provide interactive shell access.\n" >&2
	fi
fi
