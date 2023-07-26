# TODO



## Improvements


### Code
- more factorization of `lib/repos.sh`
- install: use system user?


### Features
- different permissions for admins (e.g. add users but not delete them, manage pubkeys, etc.)
- keep track of version


### Packaging
- man page
- AUR package


### Commands
- repo info: add tab before each branch line
- repo info: last commit: show first part of commit hash
- repo ls: list repos with access to others (-r or -w)
- repo unpublish: add confirm message
- key show: command for viewing public keys
- whoami: command for printing the current user


### Security and safety
- file locks and concurrency mechanisms
- check printf calls and use %s to avoid format abuse
- configuration validity check
- check when launching scripts that they run from the shell (so env variables are set) and/or set some fallback mechanism for when commands are not run by the shell
- make the code more secure to avoid argument injection (e.g. arguments containing `/` or regex elements (`*`))
- check key names (and better check usernames and repo names)



## Fixes
- repo info: fix default branch issue



## Docs
- add GIF to README
- *how it works* section in README/manual



## Ideas
- uninstall script
- complete interactive shell, with completion, history (up arrow key) and quoted string parsing (multiple word repo/key names)
- last access date and IP per user (`$SSH_CONNECTION`)
- config flag to make every repo accessible by the owner, another flag for admins (?). Should this also give permission to manage?
- client side completion engine (user list?)
