. $GK_LIB/strings.sh

# getPermsReadable echoes the permission code corresponding to $1. If not valid, outputs -1.
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
# $1: owner/repo (valid combination)
# $2: username
getPermsReadable(){
	perms=$(getRepoPerms "$1")
	if ! matches "$perms" "$2: rw?\+?"; then
		echo none
	else
		printf "$perms\n" | sed -n "s/$2: \(rw\?+\?\)\$/\1/p"
	fi
}

# getPerms echoes the permission code for $2 on repo $1.
# arguments and format:
# $1: owner/repo (valid)
# $2: username
getPerms(){
	echo $(permCode "$(getPermsReadable $@)")
}

# setPerms sets the permissions for $2 on repo $1 to $3.
# arguments and format:
# $1: owner/repo (valid)
# $2: username (valid)
# $3: readable permissions (none|rw?\+?)
setPerms(){
	repoPath="$GK_REPO_PATH/$1.git"
	permPath="$repoPath/gk_perms"
	sed -i "/^$2: rw\?\$/d" "$permPath"
	if [ "$3" != "none" ]; then
		printf "$2: $3\n" >> "$permPath"
	fi
}

# getPermsReadable lists all permission rules for the repo $1.
# arguments and format:
# $1: owner/repo (valid combination)
getRepoPerms(){
	repoPath="$GK_REPO_PATH/$1.git"
	cat "$repoPath/gk_perms"
}
