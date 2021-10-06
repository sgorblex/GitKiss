#!/bin/sh

DESCRIPTION="install.sh: install a GitKiss server"
USAGE="USAGE: install.sh [-h] OPTIONS

Where OPTIONS are from [default in square brackets]:
	-s username	system username for GitKiss [gitkiss]
	-d PATH		system user's home directory [/srv/gitkiss]
	-p PATH		GitKiss repository (library and configuration) path [\$HOME/gitkiss]
	-r PATH	 	path of the users' repositories [\$HOME/repositories]
	-u PATH	 	userlist file path [\$GK_PATH/users]
	-a PATH	 	adminlist file path [\$GK_PATH/admins]
	-t PATH	 	authorized_keys file path [\$HOME/.ssh/authorized_keys]
	-o PATH	 	owner's GitKiss username [stdin]
	-k PATH	 	owner's public key file [stdin]
	-f		force installation if user or installation directory already exist

	-h	shows this help

\$HOME is the GitKiss system user's home and \$GK_PATH is the GitKiss repository path."

set -e

help(){
	printf "%s\n%s\n" "$DESCRIPTION" "$USAGE" && exit $1
}

REPO_URL="https://github.com/sgorblex/GitKiss.git"

OPTIND=1
while getopts "hs:d:p:r:u:a:t:o:k:f" opt; do
	case "$opt" in
		h)
			help 0
			;;
		\?)
			help 1
			;;
		s)
			SYSTEM_USER="$OPTARG"
			;;
		d)
			USER_HOME="$OPTARG"
			;;
		p)
			GK_PATH="$OPTARG"
			;;
		r)
			GK_REPO_PATH="$OPTARG"
			;;
		u)
			GK_USERLIST="$OPTARG"
			;;
		a)
			GK_ADMINLIST="$OPTARG"
			;;
		t)
			GK_AUTHORIZED_KEYS="$OPTARG"
			;;
		o)
			GK_OWNER="$OPTARG"
			;;
		k)
			KEYFILE="$OPTARG"
			;;
		f)
			FORCE=yes
			;;
	esac
done
shift $((OPTIND-1))

SYSTEM_USER=${SYSTEM_USER:-"gitkiss"}
USER_HOME=${USER_HOME:-"/srv/gitkiss"}
GK_PATH=${GK_PATH:-"$USER_HOME/gitkiss"}
GK_REPO_PATH=${GK_REPO_PATH:-"$USER_HOME/repositories"}
GK_USERLIST=${GK_USERLIST:-"$GK_PATH/users"}
GK_ADMINLIST=${GK_ADMINLIST:-"$GK_PATH/admins"}
GK_AUTHORIZED_KEYS=${GK_AUTHORIZED_KEYS:-"$USER_HOME/.ssh/authorized_keys"}

SSH_DIR="${GK_AUTHORIZED_KEYS%/*}"

if [ "$SYSTEM_USER" != $(whoami) ]; then
	sudo useradd -md "$USER_HOME" "$SYSTEM_USER" || [ -n $FORCE ]
	sudo -u "$SYSTEM_USER" git clone "$REPO_URL" "$GK_PATH" || [ -n $FORCE ]
	sudo -u "$SYSTEM_USER" "$GK_PATH/install.sh" \
		-s "$SYSTEM_USER" \
		-d "$USER_HOME" \
		-p "$GK_PATH" \
		-r "$GK_REPO_PATH" \
		-u "$GK_USERLIST" \
		-a "$GK_ADMINLIST" \
		-t "$GK_AUTHORIZED_KEYS" \
		-o "$GK_OWNER" \
		-k "$KEYFILE"
	if [ -d /usr/lib/systemd/system ]; then
		sudo -u $SYSTEM_USER sed -i "s:GK_PATH:$GK_PATH:" $GK_PATH/gitkiss-daemon.service
		sudo cp $GK_PATH/gitkiss-daemon.service /usr/lib/systemd/system/gitkiss-daemon.service
		sudo systemctl enable --now gitkiss-daemon.service
	fi

else
	GK_LIB="$GK_PATH/lib"
	. "$GK_LIB/users.sh"

	if [ -z "$GK_OWNER" ]; then
		printf "Name of the server owner: "
		while true; do
			read GK_OWNER || exit 1
			if isValidUserName "$GK_OWNER"; then
				break
			fi
			printf "Invalid user name. Insert a valid name: " >&2
		done
	elif ! isValidUserName "$GK_OWNER"; then
		printf "Invalid owner username.\n" >&2
		exit 1
	fi

	if [ -z "$KEYFILE" ]; then
		printf "Insert $GK_OWNER's public key here:\n"
		while true; do
			read key || exit 1
			if isValidKey "$key"; then
				break
			fi
			printf "Invalid key. Insert a valid key:\n" >&2
		done
	else
		key=$(cat $KEYFILE)
		if ! isValidKey "$key"; then
			printf "Invalid key.\n" >&2
			exit 1
		fi
	fi

	if [ -d "$GK_REPO_PATH" ]; then
		mv "$GK_REPO_PATH" "$GK_REPO_PATH.old"
	fi
	mkdir -p "$GK_REPO_PATH"

	mkdir -p "$SSH_DIR"
	chmod 700 "$SSH_DIR"
	printf "" > "$GK_AUTHORIZED_KEYS"
	chmod 600 "$GK_AUTHORIZED_KEYS"
	printf "" > ~/.hushlogin

	printf "" > "$GK_USERLIST"
	printf "" > "$GK_ADMINLIST"

	newUser "$GK_OWNER" "$key"
	addAdmin "$GK_OWNER"
	printf "User $GK_OWNER has been added as owner.\n" >&2

	GK_CONF="$GK_PATH/conf.sh"
	sed -i "s:^\(GK_OWNER=\).*:\1\"$GK_OWNER\":" "$GK_CONF"
	sed -i "s:^\(GK_REPO_PATH=\).*:\1\"$GK_REPO_PATH\":" "$GK_CONF"
	sed -i "s:^\(GK_USERLIST=\).*:\1\"$GK_USERLIST\":" "$GK_CONF"
	sed -i "s:^\(GK_ADMINLIST=\).*:\1\"$GK_ADMINLIST\":" "$GK_CONF"
	sed -i "s:^\(GK_AUTHORIZED_KEYS=\).*:\1\"$GK_AUTHORIZED_KEYS\":" "$GK_CONF"
fi
