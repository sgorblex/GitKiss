. $GK_LIB/strings.sh
. $GK_LIB/keys.sh
. $GK_LIB/repos.sh

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
			# TODO: substitute with perm library function
			sed -i "/^$GK_USER: \(rw\?\+\?\)/d" "$GK_REPO_PATH/$1/$repo.git/gk_perms"
		done
	done
}
