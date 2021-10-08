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

# isIn returns 0 if the word $1 is contained in the word list $2, 1 otherwise.
# arguments:
# $1: word
# $2: word list
isIn(){
	for s in $2; do
		if [ "$1" = "$s" ]; then
			return 0
		fi
	done
	return 1
}

# matches returns 0 if the string $1 matches the (extended) regex $2, 1 otherwise.
# arguments:
# $1: word
# $2: regex
matches(){
	printf "$1\n" | grep -Ex "$2" >/dev/null
}

# isOneWord returns 0 if $@ is a single word, 1 otherwise. Each argument must be a single word.
# arguments:
# $@ = $1, $2, ... : words
isOneWord(){
	[ "$1" = "$@" ]
}

fi
