# listRepos lists $1's repos
listRepos(){
	ls "$GK_REPO_PATH/$1" | sed -n 's/^\(.*\)\.git$/\1/p'
}

# returns 0 if $1 is public (format of $1: author/repo)
isPublic(){
	[ -f "$GK_REPO_PATH/$1.git/git-daemon-export-ok" ]
}
