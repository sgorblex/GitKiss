permCode(){
	if [ "$1" = "r" ]; then
		echo 1
	elif [ "$1" = "rw" ]; then
		echo 2
	elif [ "$1" = "none" ]; then
		echo 0
	else
		echo -1
	fi
}

# input format: owner/repo user
getPerms(){
	repo_path="$GK_REPO_PATH/$1.git"
	perms_path=$repo_path/gk_perms
	if ! grep -Ex "$2: rw?\+?" $perms_path >/dev/null; then
		echo 0
	else
		perms=$(sed -n "s/$2: \(rw\?\)+\?\$/\1/p" $perms_path)
		echo $(permCode $perms)
	fi
}
