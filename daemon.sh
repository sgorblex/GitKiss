#!/bin/sh

GK_PATH=$(readlink -f "${0%/*}")
GK_CONF="$GK_PATH/conf.sh"
. "$GK_CONF"

printf "Starting daemon on repo path %s\n" "$GK_REPO_PATH"
/usr/bin/git daemon --reuseaddr --base-path=$GK_REPO_PATH
