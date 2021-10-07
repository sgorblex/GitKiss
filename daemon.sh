#!/bin/sh
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


GK_PATH=$(readlink -f "${0%/*}")
GK_CONF="$GK_PATH/conf.sh"
. "$GK_CONF"

printf "Starting daemon on repo path %s\n" "$GK_REPO_PATH"
/usr/bin/git daemon --reuseaddr --base-path=$GK_REPO_PATH
