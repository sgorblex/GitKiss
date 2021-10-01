#!/bin/sh

# this script is very temporary. It is not even really clear when it should be executed.

set -e

GK_PATH=$(readlink -f "${0%/*}")
GK_CONF="$GK_PATH/conf.sh"
GK_LIB="$GK_PATH/lib"
. "$GK_LIB/conf.sh"

. "$GK_LIB/pubKeys.sh"

SSH_DIR="${GK_AUTHORIZED_KEYS%/*}"

if [ -f "$GK_ADMINLIST" -o -d "$SSH_DIR" ]; then
	printf "WARNING: this will erase any pre-existing installation, including any registered public keys. Are you sure? (yes/no)\n"
	read ans
	if [ "$ans" != "yes" ]; then
		printf "Operation canceled\n" >&2
		exit 0
	fi
fi

if [ -f "$GK_REPO_PATH" ]; then
	mv "$GK_REPO_PATH" "$GK_ARCHIVE_PATH"
fi
mkdir -p "$GK_REPO_PATH"
echo > ~/.hushlogin

sed -i "s/GK_PATH/$GK_PATH/" $GK_PATH/gitkiss-daemon.service

printf "Insert owner's key here:\n"
while true; do
	read key
	if isValidKey "$key"; then
		break
	fi
	printf "Invalid key. Insert a valid key:\n" >&2
done

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"
namedKey=$(nameKey "$key" "default")
printf 'no-port-forwarding,no-X11-forwarding,no-agent-forwarding,environment="GK_USER=%s" %s\n' "$GK_OWNER" "$namedKey" > "$GK_AUTHORIZED_KEYS"
chmod 600 "$GK_AUTHORIZED_KEYS"
if ! ssh-keygen -lf "$GK_AUTHORIZED_KEYS" > /dev/null; then
	printf "\nAn error occurred.\n" >&2
	rm "$GK_AUTHORIZED_KEYS"
	exit 1
fi
printf "$GK_OWNER\n" > "$GK_USERLIST"
printf "$GK_OWNER\n" > "$GK_ADMINLIST"
mkdir -p "$GK_REPO_PATH/$GK_OWNER"

printf "\nOwner's key successfully installed.\n"
