#!/bin/sh

DESCRIPTION="repo: manage your repositories"
USAGE="USAGE: repo [-h | --help] COMMAND [flags] [arguments]

Where COMMAND is one of:
	ls [verb] [arguments]	lists the repositories you have access to (see ls --help)
	new [repo name]		creates a new repository with the specified name
	rm [repo name]		deletes the repository with the specified name
	publish [repo name]	publishes the repository with the specified name
				to git-daemon (read only git protocol)
	unpublish [repo name]	unpublishes the repository with the specified name
				from git-daemon (git protocol)
	perm [verb] [arguments]	lists/sets permissions for your repos

OPTIONS:
	-h | --help		shows this help"

set -e

. $GK_LIB/users.sh
. $GK_LIB/strings.sh
. $GK_LIB/perms.sh

if ! isUser $GK_USER; then
	printf "repo: You are not a valid user.\n" >&2
	exit 1
fi

if [ -z "$1" ]; then
	printf "repo: Please specify a command.\n" >&2
	exit 1
fi



lsRepo() {
	LS_USAGE="USAGE: repo ls [-h | --help] [VERB] [arguments]

Where VERB is one of:
	mine			lists the repositories you own (default)
	all			lists all the repositories you have access to
	user [username]		lists the repositories owned by username that you have access to

OPTIONS:
	-h | --help		shows this help"

	lsRepoMine(){
		printf "Repositories owned by $GK_USER:\n"

		for repo in $GK_REPO_PATH/$GK_USER/*; do
			repo=${repo##*/}
			printf "${repo%.git}\n"
		done
	}

	case "$1" in
		"mine"|"")
			lsRepoMine
			;;
		"all")
			lsRepoAll
			;;
		"user")
			shift
			lsRepoUser $@
			;;
		"--help" | "-h")
			printf "$LS_USAGE\n"
			;;
		*)
			printf "repo: ls: Unrecognised verb.\n" >&2
			exit 1
			;;
	esac
}

rmRepo() {
	if [ -z "$1" ]; then
		printf "repo: rm: Insert repo name as argument\n" >&2
		exit 1
	fi

	repo="${@%.git}"
	repo_path="$GK_REPO_PATH/$GK_USER/${repo}.git"

	if [ ! -d "$repo_path" ]; then
		printf "repo: rm: A repository with such name does not exist.\n" >&2
		exit 1
	fi

	rm -rf "$repo_path"
	printf "Repository deleted successfully.\n"
}

newRepo() {
	if [ -z "$1" ]; then
		printf "repo: new: Insert repo name as argument.\n" >&2
		exit 1
	fi

	if matches "$1" ".*/.*"; then
		printf 'repo: new: "%s" is not a valid name.\n' "$1" >&2
		exit 1
	fi

	repo="${@%.git}"
	repo_path="$GK_REPO_PATH/$GK_USER/${repo}.git"

	if [ -d "$repo_path" ]; then
		printf 'repo: new: the repository "%s" already exists.\n' "$repo" >&2
		exit 1
	fi

	mkdir "$repo_path"
	git init --bare -q "$repo_path"
	printf "$GK_USER: rw+\n" > "$repo_path/gk_perms"
	printf "Repository created successfully.\n"
}

publishRepo() {
	if [ -z "$1" ]; then
		printf "repo: publish: Insert repo name as argument.\n" >&2
		exit 1
	fi

	repo="${@%.git}"
	repo_path="$GK_REPO_PATH/$GK_USER/${repo}.git"

	if [ ! -d "$repo_path" ]; then
		printf "repo: publish: A repository with such name does not exist.\n" >&2
		exit 1
	fi

	if [ -f "$repo_path/git-daemon-export-ok" ]; then
		printf "repo: publish: This repo is already public.\n" >&2
		exit 1
	fi

	printf > "$repo_path/git-daemon-export-ok" 
	printf "Repository published successfully.\n"
}

unpublishRepo() {
	if [ -z "$1" ]; then
		printf "repo: unpublish: Insert repo name as argument\n" >&2
		exit 1
	fi

	repo="${@%.git}"
	repo_path="$GK_REPO_PATH/$GK_USER/${repo}.git"

	if [ ! -d "$repo_path" ]; then
		printf "repo: unpublish: A repository with such name does not exist.\n" >&2
		exit 1
	fi

	if [ -f "$repo_path/git-daemon-export-ok" ]; then
		printf "repo: unpublish: This repo is already public.\n" >&2
		exit 1
	fi

	rm "$repo_path/git-daemon-export-ok" 
	printf "Repository unpublished successfully."
}

permRepo(){
	PERM_USAGE="USAGE: repo perm [-h | --help] [VERB] [arguments]

Where VERB is one of:
	ls [repo]			lists user permissions for the specified repo
	set [repo] [username] [PERM]	grants read (r) or read+write (rw) permission to the specified user

Where PERM is one of:
	r				read only
	rw				read and write
	none				no permission


OPTIONS:
	-h | --help		shows this help"

	permRepoLs(){
		if [ -z "$1" ]; then
			printf "repo: perm: ls: Insert repo name as argument\n" >&2
			exit 1
		fi

		repo="${@%.git}"
		repo_path="$GK_REPO_PATH/$GK_USER/${repo}.git"

		if [ ! -d "$repo_path" ]; then
			printf "repo: perm: ls: A repository with such name does not exist.\n" >&2
			exit 1
		fi

		printf "Permissions for repo $repo:\n"
		cat $repo_path/gk_perms
	}

	permRepoSet(){
		if [ -z "$1" ]; then
			printf "repo: perm: grant: Insert repo name as argument\n" >&2
			exit 1
		fi

		repo="${1%.git}"
		repo_path="$GK_REPO_PATH/$GK_USER/${repo}.git"
		perms_path=$repo_path/gk_perms

		if [ ! -d "$repo_path" ]; then
			printf "repo: perm: set: A repository with such name does not exist.\n" >&2
			exit 1
		fi

		if ! isUser "$2"; then
			printf "repo: perm: set: No such user: $2.\n" >&2
			exit 1
		fi

		if [ "$2" = "$GK_USER" ]; then
			printf "repo: perm: set: You can't set your own permissions (you are the owner!).\n" >&2
			exit 1
		fi

		perm_code=$(permCode "$3")
		if [ $perm_code -eq -1 ]; then
			printf "repo: perm: set: Invalid permissions: $3.\n" >&2
			exit 1
		fi

		sed -i "/^$2: rw\?\$/d" $perms_path
		if [ $perm_code -ne 0 ]; then
			printf "$2: $3\n" >> $perms_path
		fi

		printf "Permissions set.\n"
	}

	case "$1" in
		"ls")
			shift
			permRepoLs $@
			;;
		"set")
			shift
			permRepoSet $@
			;;
		"--help" | "-h")
			printf "$PERM_USAGE\n"
			;;
		*)
			printf "repo: perm: Unrecognised verb.\n" >&2
			exit 1
	esac
}

case "$1" in
	"ls")
		shift
		lsRepo $@
		;;
	"new")
		shift
		newRepo $@
		;;
	"rm")
		shift
		rmRepo $@
		;;
	"publish")
		shift
		publishRepo $@
		;;
	"unpublish")
		shift
		unpublishRepo $@
		;;
	"perm")
		shift
		permRepo $@
		;;
	"--help" | "-h")
		printf "%s\n%s\n" "$DESCRIPTION" "$USAGE"
		;;
	*)
		printf "Unrecognised command.\n" >&2
		exit 1
		;;
esac
