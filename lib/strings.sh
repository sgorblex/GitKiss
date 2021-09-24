matches(){
	echo "$1" | grep -Ex "$2" > /dev/null
}
