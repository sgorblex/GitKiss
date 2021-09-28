isIn(){
	for s in $2; do
		if [ "$1" = "$s" ]; then
			return 0
		fi
	done
	return 1
}

matches(){
	echo "$1" | grep -Ex "$2" &> /dev/null
}
