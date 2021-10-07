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


if [ -z "$GK_IMP_LIB_CONF" ]; then
GK_IMP_LIB_CONF=1

# read config file
. "$GK_CONF"

# export set configuration
export GK_PATH
export GK_CONF
export GK_COMMANDS
export GK_LIB

export GK_OWNER
export GK_REPO_PATH
export GK_MAX_REPOS
export GK_ARCHIVE_PATH
export GK_INTERACTIVE
export GK_MOTD
export GK_PROMPT
export GK_ERR_PROMPT
export GK_MAX_USERS
export GK_AUTHORIZED_KEYS
export GK_MAX_KEYS
export GK_USERLIST
export GK_ADMINLIST

fi
