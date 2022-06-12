# Copyright (C) 2021 Alessandro "sgorblex" Clerici Lorenzini.
#
# This file is part of GitKiss.
#
# GitKiss is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# GitKiss is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with GitKiss.  If not, see <https://www.gnu.org/licenses/>.


if [ -z "$GK_IMP_LIB_REPOS" ]; then
GK_IMP_LIB_REPOS=1

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
	printf "\n" > "$repoPath/description"
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

# isBranch returns 0 if $2 is a valid branch for repo $1, 1 otherwise.
# arguments and format:
# $1: owner/repo (valid combination)
# $2: branch name
isBranch(){
	repoPath="$GK_REPO_PATH/$1.git"
	[ -f "$repoPath/refs/heads/$2" ]
}

# isEmptyRepo returns 0 if $1 is an empty repo, 1 otherwise.
# arguments and format:
# $1: owner/repo (valid combination)
isEmptyRepo(){
	repoPath="$GK_REPO_PATH/$1.git"
	[ -z "$(ls -A $repoPath/refs/heads)" ]
}

# defBranchRepo sets the default branch of the repo $1 to $2.
# arguments and format:
# $1: owner/repo (valid combination)
# $2: branch (valid)
defBranchRepo(){
	repoPath="$GK_REPO_PATH/$1.git"
	cd "$repoPath"
	git symbolic-ref HEAD "refs/heads/$2"
}

# treeRepo prints a tree representation of the repo $1 on branch $2.
# arguments and format:
# $1: owner/repo (valid combination)
# $2: branch (valid)
treeRepo(){
	repoPath="$GK_REPO_PATH/$1.git"
	cd "$repoPath"
	printf "$1\n" && git ls-tree -tr --name-only "$2" | tree --fromfile | sed '1d'
}

# listBranches lists the branches of the repo $1.
# arguments:
# $1: owner/repo (valid combination)
listBranches(){
	repoPath="$GK_REPO_PATH/$1.git"
	ls -A "$repoPath/refs/heads"
}

# listBranches prints the size of the repo $1.
# arguments:
# $1: owner/repo (valid combination)
repoSize(){
	repoPath="$GK_REPO_PATH/$1.git"
	du -csh "$repoPath" | head -1 | cut -f 1
}

# repoDefBranch prints the default branch of the repo $1.
# arguments:
# $1: owner/repo (valid combination)
repoDefBranch(){
	repoPath="$GK_REPO_PATH/$1.git"
	head=$(cat "$repoPath/HEAD")
	printf "${head##ref: refs/heads/}\n"
}

# repoLastCommit prints the last commit message for the repo $1.
# arguments:
# $1: owner/repo (valid combination)
repoLastCommit(){
	repoPath="$GK_REPO_PATH/$1.git"
	cd "$repoPath"
	git log --format=%B -n 1
}

# repoSetDesc sets the description of the repo $1 to $2.
# arguments:
# $1: owner/repo (valid combination)
# $2: new description
repoSetDesc(){
	repoPath="$GK_REPO_PATH/$1.git"
	printf "$2\n" > "$repoPath/description"
}

# repoGetDesc prints the description of the repo $1.
# arguments:
# $1: owner/repo (valid combination)
repoGetDesc(){
	repoPath="$GK_REPO_PATH/$1.git"
	cat "$repoPath/description"
}

fi
