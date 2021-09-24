PUB_KEY_RE="(ssh-(rsa|dss|ed25519)|ecdsa-sha2-nistp(256|384|521)|) [a-zA-Z0-9/+]+==?.*"

. $GK_LIB/strings.sh

isValidKey(){
	matches "$1" "$PUB_KEY_RE"
}
