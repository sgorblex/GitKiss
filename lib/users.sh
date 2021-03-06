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


if [ -z "$GK_IMP_LIB_USERS" ]; then
GK_IMP_LIB_USERS=1

. $GK_LIB/strings.sh
. $GK_LIB/keys.sh
. $GK_LIB/repos.sh
. $GK_LIB/perms.sh

# listAdmins lists the server's admins.
listAdmins(){
	cat "$GK_ADMINLIST"
}

# listUsers lists the server's users.
listUsers(){
	cat "$GK_USERLIST"
}

# userNumber echoes the number of users of the server.
userNumber(){
	listUsers | wc -l
}

# isOwner returns 0 if $1 is the server owner, 1 otherwise.
# arguments:
# $1: a name
isOwner(){
	[ "$1" = "$GK_OWNER" ]
}

# isAdmin returns 0 if $1 is a server admin, 1 otherwise.
# arguments:
# $1: a name
isAdmin(){
	isIn "$1" "$(listAdmins)"
}

# isUser returns 0 if $1 is a server user, 1 otherwise.
# arguments:
# $1: a name
isUser(){
	isIn "$1" "$(listUsers)"
}

# addAdmin adds $1 to the server admins.
# arguments:
# $1: username (valid)
addAdmin(){
	printf "$1\n" >> "$GK_ADMINLIST"
}

# rmAdmin removes $1 from the server admins.
# arguments:
# $1: username (valid admin)
rmAdmin(){
	sed -i "/^$1$/d" "$GK_ADMINLIST"
}

# isValidUserName returns 0 if $1 is a valid name for a user, 1 otherwise.
# arguments:
# $1: candidate name
isValidUserName(){
	isOneWord $1 &&	! matches "$1" '.*[/:\|].*'
}

# newUser adds $1 to the server users with the pubkey $2.
# arguments:
# $1: username
# $2: public key for the user
newUser(){
	printf "$1\n" >> "$GK_USERLIST"
	mkdir "$GK_REPO_PATH/$1"
	addKey "$1" "default" "$2"
}

# rmUser removes $1 from the server users.
# arguments:
# $1: username (valid)
rmUser(){
	if [ -n "$GK_ARCHIVE_PATH" ]; then
		mkdir -p "$GK_ARCHIVE_PATH"
		mv "$GK_REPO_PATH/$1" "$GK_ARCHIVE_PATH/"
	else
		rm -rf "$GK_REPO_PATH/$1"
	fi

	sed -i "/^$1$/d" "$GK_USERLIST"
	sed -i "/^$(keyPreamble $1)/d" "$GK_AUTHORIZED_KEYS"

	for user in $(listUsers); do
		for repo in $(listRepos "$1"); do
			setPerms "$user/$repo" "$1" "none"
		done
	done
}

fi
