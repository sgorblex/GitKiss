#!/bin/sh


set -e

export GK_PATH=${0%/*}
export GK_CONF=$GK_PATH/conf
export GK_COMMANDS=$GK_PATH/commands
export GK_LIB=$GK_PATH/lib
. $GK_CONF/conf

. $GK_LIB/checkKey.sh

printf "Insert owner's key here:\n"

while 0; do
	read $key
	if isValidKey "$key"; then
		break
	fi
	printf "Invalid key. Insert a valid key:\n"
done

mkdir -p ${GK_AUTHORIZED_KEYS%/*}
printf 'no-port-forwarding,no-X11-forwarding,no-agent-forwarding,environment="GK_USER=%s %s"' $GK_USER $key > $GK_AUTHORIZED_KEYS
if ! ssh-keygen -lf $GK_AUTHORIZED_KEYS; then
	printf "An error occurred."
	rm $GK_AUTHORIZED_KEYS
	exit 1
fi

printf "Owner's key successfully installed."
