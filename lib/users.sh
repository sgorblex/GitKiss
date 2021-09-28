. $GK_LIB/strings.sh

isOwner(){
	[ "$1" = "$GK_OWNER" ]
}

isAdmin(){
	isIn "$1" "$(cat "$GK_ADMINLIST")"
}

isUser(){
	isIn "$1" "$(cat "$GK_USERLIST")"
}
