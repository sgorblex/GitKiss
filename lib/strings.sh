isIn(){
	for s in $2; do
		if [ "$1" = "$s" ]; then
			return 0
		fi
	done
	return 1
}

matches(){
	printf "$1\n" | grep -Ex "$2" >/dev/null
}

# $1 must be a single word
isOneWord(){
	[ "$1" = "$@" ]
}
