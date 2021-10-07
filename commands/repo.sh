#!/bin/sh
# Copyright (C) 2021 Alessandro "sgorblex" Clerici Lorenzini.
#
# This file is part of GitKiss.
#
# GitKiss is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# GitKiss is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with GitKiss.  If not, see <https://www.gnu.org/licenses/>.


DESCRIPTION="repo: manage your repositories"
USAGE="USAGE: repo [-h | --help] COMMAND [flags] <arguments>

Where COMMAND is one of:
	ls [-h | --help] <verb> <arguments>	lists the repositories you have access to (see --help)
	new <repo name>				creates a new repository with the specified name
	rm <repo name>				deletes the repository with the specified name
	publish <repo name>			publishes the repository with the specified name
						to git-daemon (read only git protocol)
	unpublish <repo name>			unpublishes the repository with the specified name
						from git-daemon (git protocol)
	perm <verb> <arguments>			lists/sets permissions for your repos

OPTIONS:
	-h | --help				shows this help

Maximum number of repositories per user is $GK_MAX_REPOS by the current configuration"

set -e

. "$GK_LIB/perms.sh"
. "$GK_LIB/repos.sh"
. "$GK_LIB/strings.sh"
. "$GK_LIB/users.sh"


if ! isUser "$GK_USER"; then
	printf "repo: You are not a valid user.\n" >&2
	exit 1
fi

if [ -z "$1" ]; then
	printf "repo: Please specify a command.\n" >&2
	exit 1
fi



repo_ls() {
	LS_USAGE="USAGE: repo ls [-h | --help] [VERB] [arguments]

Where VERB is one of:
	mine			lists the repositories you own (default)
	all			lists all the repositories you have access to
	user <username>		lists the repositories owned by username that you have access to
	public [username]	list public repositories owned by username or by anyone if no username is given

OPTIONS:
	-h | --help		shows this help"

	repo_ls_mine(){
		printf "Repositories owned by $GK_USER:\n"
		listRepos "$GK_USER"
	}

	repo_ls_all(){
		printf "Repositories that you have access to:\n"

		for user in $(listUsers); do
			for repo in $(listRepos "$user"); do
				if [ $(getPerms "$user/$repo" "$GK_USER") -gt 0 ]; then
					printf "$user/$repo:   $(getPermsReadable "$user/$repo" "$GK_USER")\n"
			fi
			done
		done
	}

	repo_ls_user(){
		if [ -z "$1" ]; then
			printf "repo: ls: user: Please provide an username.\n" >&2
		fi

		if ! isUser "$1"; then
			printf "repo: ls: user: $1 is not a valid user.\n" >&2
			exit 1
		fi

		printf "Repositories owned by $1 that you have access to:\n"

		for repo in $(listRepos "$1"); do
			if [ $(getPerms "$1/$repo" "$GK_USER") -gt 0 ]; then
				printf "$repo: $(getPermsReadable "$1/$repo" "$GK_USER")\n"
			fi
		done
	}

	repo_ls_public(){
		if [ -z "$1" ]; then
			printf "Public repositories:\n"
			for user in $(listUsers); do
				for repo in $(listRepos "$user"); do
					if isPublic "$user/$repo"; then
						printf "$user/$repo\n"
					fi
				done
			done
			exit 0
		fi

		if ! isUser "$1"; then
			printf "repo: ls: public: $1 is not a valid user.\n" >&2
			exit 1
		fi

		printf "Public repositories owned by $1:\n"
		for repo in $(listRepos "$1"); do
			if isPublic "$1/$repo"; then
				printf "$repo\n"
			fi
		done
	}

	case "$1" in
		"mine"|"")
			repo_ls_mine
			;;
		"all")
			repo_ls_all
			;;
		"user")
			shift
			repo_ls_user $@
			;;
		"public")
			shift
			repo_ls_public $@
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

repo_rm() {
	if [ -z "$1" ]; then
		printf "repo: rm: Insert repo name as argument\n" >&2
		exit 1
	fi
	repo="${@%.git}"

	if ! isRepo "$GK_USER/$repo"; then
		printf "repo: rm: A repository with such name does not exist.\n" >&2
		exit 1
	fi

	rmRepo "$GK_USER/$repo"
	printf "Repository deleted successfully.\n"
}

repo_new() {
	if [ -z "$1" ]; then
		printf "repo: new: Insert repo name as argument.\n" >&2
		exit 1
	fi
	repo="${1%.git}"

	if [ $(repoNumber "$GK_USER") -ge "$GK_MAX_REPOS" ]; then
		printf "repo: new: You cannot create any more repos. Maximum number $GK_MAX_REPOS exceeded.\n" >&2
		exit 1
	fi

	if ! isValidRepoName "$repo"; then
		printf 'repo: new: "%s" is not a valid name.\n' "$repo" >&2
		exit 1
	fi

	if isRepo "$GK_USER/$repo"; then
		printf 'repo: new: the repository "%s" already exists.\n' "$repo" >&2
		exit 1
	fi

	newRepo "$GK_USER/$repo"
	printf "Repository created successfully.\n"
}

repo_publish() {
	if [ -z "$1" ]; then
		printf "repo: publish: Insert repo name as argument.\n" >&2
		exit 1
	fi
	repo="${1%.git}"

	if ! isRepo "$GK_USER/$repo"; then
		printf "repo: publish: A repository with such name does not exist.\n" >&2
		exit 1
	fi

	if isPublic "$GK_USER/$repo"; then
		printf "repo: publish: This repo is already public.\n" >&2
		exit 1
	fi

	publishRepo "$GK_USER/$repo"
	printf "Repository published successfully.\n"
}

repo_unpublish() {
	if [ -z "$1" ]; then
		printf "repo: unpublish: Insert repo name as argument\n" >&2
		exit 1
	fi
	repo="${1%.git}"

	if ! isRepo "$GK_USER/$1"; then
		printf "repo: unpublish: A repository with such name does not exist.\n" >&2
		exit 1
	fi

	if ! isPublic "$GK_USER/$1"; then
		printf "repo: unpublish: This repo is not public.\n" >&2
		exit 1
	fi
	exit 42

	unpublishRepo "$GK_USER/$repo"
	printf "Repository unpublished successfully.\n"
}

repo_perm(){
	PERM_USAGE="USAGE: repo perm [-h | --help] <VERB> <arguments>

Where VERB is one of:
	ls <repo>			lists user permissions for the specified repo
	set <repo> <username> <PERM>	grants read (r) or read+write (rw) permission to the specified user

Where PERM is one of:
	r				read only
	rw				read and write
	none				no permission


OPTIONS:
	-h | --help			shows this help"

	repo_perm_ls(){
		if [ -z "$1" ]; then
			printf "repo: perm: ls: Insert repo name as argument\n" >&2
			exit 1
		fi
		repo="${1%.git}"

		if ! isRepo "$GK_USER/$repo"; then
			printf "repo: perm: ls: A repository with such name does not exist.\n" >&2
			exit 1
		fi

		printf "Permissions for repo $repo:\n"
		getRepoPerms "$GK_USER/$repo"
	}

	repo_perm_set(){
		if [ -z "$1" ]; then
			printf "repo: perm: grant: Insert repo name as argument\n" >&2
			exit 1
		fi
		repo="${1%.git}"

		if ! isRepo "$GK_USER/$repo"; then
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

		if [ "$(permCode "$3")" -eq -1 ]; then
			printf "repo: perm: set: Invalid permissions: $3.\n" >&2
			exit 1
		fi

		setPerms "$GK_USER/$repo" "$2" "$3"
		printf "Permissions set.\n"
	}

	case "$1" in
		"ls")
			shift
			repo_perm_ls $@
			;;
		"set")
			shift
			repo_perm_set $@
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
		repo_ls $@
		;;
	"new")
		shift
		repo_new $@
		;;
	"rm")
		shift
		repo_rm $@
		;;
	"publish")
		shift
		repo_publish $@
		;;
	"unpublish")
		shift
		repo_unpublish $@
		;;
	"perm")
		shift
		repo_perm $@
		;;
	"--help" | "-h")
		printf "%s\n%s\n" "$DESCRIPTION" "$USAGE"
		;;
	*)
		printf "Unrecognised command.\n" >&2
		exit 1
		;;
esac
