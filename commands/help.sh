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


. "$GK_LIB/users.sh"

printf "Available commands for user $GK_USER:\n"

if isOwner $GK_USER; then
	printf "\n"
	printf "OWNER COMMANDS:\n"
	printf "admin:\tmanage admins\n"
fi

if isAdmin $GK_USER; then
	printf "\n"
	printf "ADMIN COMMANDS:\n"
	printf "user:\tmanage users\n"
fi



printf "\n"
printf "repo:\tmanage repos\n"
printf "key:\tmanage ssh public keys\n"
printf "help:\tshow this help\n"
