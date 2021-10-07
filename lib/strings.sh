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


if [ -z "$GK_IMP_LIB_STRINGS" ]; then
GK_IMP_LIB_STRINGS=1

isIn(){
	for s in $2; do
		if [ "$1" = "$s" ]; then
			return 0
		fi
	done
	return 1
}

matches(){
	printf "$1\n" | grep -Ex "$2" >/dev/null
}

# $1 must be a single word
isOneWord(){
	[ "$1" = "$@" ]
}

fi
