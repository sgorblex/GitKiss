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


DESCRIPTION="admin: manage GitKiss admins"
USAGE="USAGE: admin [-h | --help] COMMAND [arguments]

Where COMMAND is one of:
	ls			lists the existing admins
	add <username>		add the specified user to the admins
	rm <admin name>		removes the specified user from the admins

OPTIONS:
	-h | --help		shows this help"

set -e

. "$GK_LIB/users.sh"


if ! isOwner "$GK_USER"; then
	printf "admin: This command can only be run by the server owner.\n" >&2
	exit 1
fi

if [ -z "$1" ]; then
	printf "admin: Please specify a command.\n" >&2
	exit 1
fi


admin_ls(){
	listAdmins
}


admin_add(){
	if ! isUser "$1"; then
		printf "admin: $1 is not a valid user.\n" >&2
		exit 1
	elif isAdmin "$1"; then
		printf "admin: $1 is already an admin.\n" >&2
		exit 1
	fi

	addAdmin "$1"
	printf "$1 is now an admin.\n"
}


admin_rm(){
	if ! isUser "$1"; then
		printf "admin: $1 is not a valid user.\n" >&2
		exit 1
	elif ! isAdmin "$1"; then
		printf "admin: $1 is not an admin.\n" >&2
		exit 1
	elif [ "$1" = "$GK_USER" ]; then
		printf "admin: You can't remove yourself (the owner) from the admins." >&2
		exit 1
	fi

	rmAdmin "$1"
	printf "$1 has been removed from the admins.\n"
}


case "$1" in
	"ls")
		admin_ls
		;;
	"add")
		shift
		admin_add $@
		;;
	"rm")
		shift
		admin_rm $@
		;;
	"--help" | "-h")
		printf "%s\n%s\n" "$DESCRIPTION" "$USAGE"
		;;
	*)
		printf "admin: Unrecognised command.\n" >&2
		exit 1
		;;
esac
