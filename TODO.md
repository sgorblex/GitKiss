# TODO


## Improvements
- support non `*.sh` commands
- check when launching scripts that they run from the shell (so env variables are set) and/or set some fallback mechanism for when commands are not run by the shell
- configuration validity check
- ditch `isIn` (?)
- various permissions for admins (e.g. add users but not delete them, manage pubkeys, etc.)
- key show command for viewing public keys
- man page

### "Security"
- make the code more secure to avoid argument injection (e.g. arguments containing `/` or regex elements (`*`))
- check key names (and better check usernames and repo names)

## Ideas
- uninstall script
- *how it works* section in README/manual
- `whoami` command
- complete interactive shell, with completion, history (up arrow key) and quoted string parsing (multiple word repo/key names)
- last access date and IP per user (`$SSH_CONNECTION`)
- config flag to make every repo accessible by the owner, another flag for admins (?). Should this also give permission to manage?
- client side completion engine (user list?)
- user command: add rename verb (?)
