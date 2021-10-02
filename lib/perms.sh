# getPermsReadable echoes the permission code corresponding to $1.
# arguments:
# $1: readable permissions (none|rw?\+?)
permCode(){
	case "$1" in
		"r")
			echo 1
			;;
		"rw")
			echo 2
			;;
		"rw+")
			echo 3
			;;
		"none")
			echo 0
			;;
		*)
			echo -1
	esac
}

# getPermsReadable echoes readable permissions for $2 on repo $1.
# arguments and format:
# $1: owner/repo
# $2: username
getPermsReadable(){
	repo_path="$GK_REPO_PATH/$1.git"
	perms_path="$repo_path/gk_perms"
	if ! grep -Ex "$2: rw?\+?" "$perms_path" >/dev/null; then
		echo none
	else
		echo "$(sed -n "s/$2: \(rw\?+\?\)\$/\1/p" $perms_path)"
	fi
}

# getPermsReadable echoes the permission code for $2 on repo $1.
# arguments and format:
# $1: owner/repo
# $2: username
getPerms(){
	echo $(permCode "$(getPermsReadable $@)")
}
