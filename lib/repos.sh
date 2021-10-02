. $GK_LIB/strings.sh

# listRepos lists $1's repos.
# arguments:
# $1: repo owner (a valid user)
listRepos(){
	ls "$GK_REPO_PATH/$1" | sed -n 's/^\(.*\)\.git$/\1/p'
}

# isRepo returns 0 if $1 is an existing repo, 1 otherwise.
# arguments and format:
# $1: owner/repo (valid combination)
isRepo(){
	[ -d "$GK_REPO_PATH/$1.git" ]
}

# isPublic returns 0 if $1 is public, 1 otherwise.
# arguments and format:
# $1: owner/repo (valid combination)
isPublic(){
	[ -f "$GK_REPO_PATH/$1.git/git-daemon-export-ok" ]
}

# repoNumber echoes the number of repos owned by $1.
# arguments:
# $1: repo owner (a valid user)
repoNumber(){
	listRepos "$1" | wc -l
}

# isValidRepoName returns 0 if $1 is a valid name for a repository, 1 otherwise.
# arguments:
# $1: candidate name
isValidRepoName(){
	! matches "$1" '.*/.*'
}

# newRepo creates the repo $1.
# arguments and format:
# $1: owner/repo (valid combination)
newRepo(){
	repoPath="$GK_REPO_PATH/$1.git"
	git init --bare -q "$repoPath"
	printf "${1%/*}: rw+\n" > "$repoPath/gk_perms"
}

# rmRepo deletes the repo $1.
# arguments and format:
# $1: owner/repo (valid combination)
rmRepo(){
	repoPath="$GK_REPO_PATH/$1.git"
	rm -rf "$repoPath"
}

# publishRepo publishes the repo $1 to git daemon.
# arguments and format:
# $1: owner/repo (valid combination)
publishRepo(){
	repoPath="$GK_REPO_PATH/$1.git"
	printf "" > "$repoPath/git-daemon-export-ok"
}

# unpublishRepo unpublishes the repo $1 from git daemon.
# arguments and format:
# $1: owner/repo (valid combination)
unpublishRepo(){
	repoPath="$GK_REPO_PATH/$1.git"
	rm "$repoPath/git-daemon-export-ok"
}
