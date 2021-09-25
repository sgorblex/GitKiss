. $GK_LIB/strings.sh

isOwner(){
	[ "$1" = $GK_OWNER ]
}

isAdmin(){
	isIn $1 $(cat $GK_CONF/admins)
}

isUser(){
	isIn $1 $(cat $GK_CONF/users)
}
