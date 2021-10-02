. $GK_LIB/strings.sh

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
