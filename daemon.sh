#!/bin/sh

export GK_PATH="${0%/*}"
export GK_CONF="$GK_PATH/conf.sh"
. "$GK_CONF"

printf "Daemon started on repo path %s\n" "$GK_REPO_PATH"
/usr/bin/git daemon --reuseaddr --base-path=$GK_REPO_PATH
