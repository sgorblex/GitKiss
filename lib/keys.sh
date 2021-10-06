PUB_KEY_TYPE_RE="\(ssh-\(rsa\|dss\|ed25519\)\|ecdsa-sha2-nistp\(256\|384\|521\)\)"
KEY_PREAMBLE_1="command=\"$GK_PATH/shell.sh "
KEY_PREAMBLE_2=',no-port-forwarding,no-X11-forwarding,no-agent-forwarding'

. $GK_LIB/strings.sh

# isValidKey returns 0 if $1 is a valid ssh public key, 1 otherwise. A key containing options, such as "no-port-forwarding", is considered not valid.
# arguments:
# $1: key
isValidKey(){
	key="$(echo "$1" | sed "s/\s/ /g" | cut -d ' ' -f 1,2)"
	tmpfile=$(mktemp)
	chmod 600 "$tmpfile"
	printf "$key\n" > "$tmpfile"
	if ! ssh-keygen -lf "$tmpfile" >/dev/null 2>&1 ; then
		rm "$tmpfile"
		return 1
	fi
	rm "$tmpfile"
	return 0
}

# keyPreamble outputs the key preamble for user $1.
# arguments:
# $1: username
keyPreamble(){
	printf '%s%s"%s' "$KEY_PREAMBLE_1" "$1" "$KEY_PREAMBLE_2"
}

# existsKey takes a username and a key name and returns 0 if username has a key named name
# arguments:
# $1: username (valid)
# $2: key name
existsKey(){
	isIn "$2" "$(listKeys "$1")"
}

# listKeys lists $1's public keys.
# arguments:
# $1: keys' owner (a valid user)
listKeys(){
	sed -n "s|^$(keyPreamble "$1") ||p" "$GK_AUTHORIZED_KEYS" | cut -d ' ' -f 3-
}

# keyNumber echoes the number of public keys owned by $1.
# arguments:
# $1: keys' owner (a valid user)
keyNumber(){
	listKeys "$1" | wc -l
}

# addKey adds the key $3 named $2 to $1's public keys.
# arguments:
# $1: key owner (a valid user)
# $2: key name
# $3: key (valid)
addKey(){
	printf "$(keyPreamble "$1") $3 $2\n" >> "$GK_AUTHORIZED_KEYS"
}

# rmKey deletes the key named $2 from $1's public keys.
# arguments:
# $1: key owner (a valid user)
# $2: key name
rmKey(){
	sed -i "/^$(keyPreamble "$1") $PUB_KEY_TYPE_RE [a-zA-Z0-9+\/]\+ $2/d" "$GK_AUTHORIZED_KEYS"
}

# renameKey renames the key named $2 from $1's public keys to the new name $3.
# arguments:
# $1: key owner (a valid user)
# $2: current key name
# $3: new key name
renameKey(){
	sed -i "s/^\($(keyPreamble "$1") $PUB_KEY_TYPE_RE [a-zA-Z0-9+\/]\+ \)$2/\1$3/" "$GK_AUTHORIZED_KEYS"
}
