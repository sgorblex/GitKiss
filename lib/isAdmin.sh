. $GK_LIB/strings.sh

isAdmin(){
	isIn $1 $(cat $GK_CONF/admins)
}
