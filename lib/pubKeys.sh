PUB_KEY_RE="(ssh-(rsa|dss|ed25519)|ecdsa-sha2-nistp(256|384|521)) [a-zA-Z0-9/+]+ .*"
KEY_PREAMBLE='no-port-forwarding,no-X11-forwarding,no-agent-forwarding,environment="GK_USER='

. $GK_LIB/strings.sh

isValidKey(){
	matches "$1" "$PUB_KEY_RE"
}

# nameKey takes a public key and a name and substitutes the ending string with the specified name
nameKey(){
	printf ${1%% *} $2
}

# keyPreamble takes a username and outputs the key preamble for that username (including the trailing space)
keyPreamble(){
	printf '%s%s" ' $KEY_PREAMBLE $1
}

# existsKey takes a username and a key name and returns 0 if username has a key named name
existsKey(){
	grep -Ex "$(keyPreamble $1).* $2" $GK_AUTHORIZED_KEYS &>/dev/null
}
