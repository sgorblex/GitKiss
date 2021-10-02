. $GK_LIB/strings.sh

listAdmins(){
	cat "$GK_ADMINLIST"
}

listUsers(){
	cat "$GK_USERLIST"
}

isOwner(){
	[ "$1" = "$GK_OWNER" ]
}

isAdmin(){
	isIn "$1" "$(listAdmins)"
}

isUser(){
	isIn "$1" "$(listUsers)"
}
