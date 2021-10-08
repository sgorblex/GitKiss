# TODO


## Improvements
- `clear` command (launches `sh`'s `clear`)
- Docker image
- check for unnecessary arguments in commands (check arg number prior to executing the verbs)
- improve code documentation
- check when launching scripts that they run from the shell (so env variables are set) and/or set some fallback mechanism for when commands are not run by the shell
- user command: add rename verb (?)
- configuration validity check
- ditch `isIn` (?)
- various permissions for admins (e.g. add users but not delete them, manage pubkeys, etc.)
- key show command for viewing public keys

### "Security"
- make the code more secure to avoid argument injection (e.g. arguments containing `/` or regex elements (`*`))
- check key names (and better check usernames and repo names)

## Ideas
- *how it works* section in README
- `whoami` command
- up arrow key for last command in interactive shell
- last access date and IP per user (`$SSH_CONNECTION`)
- config flag to make every repo accessible by the owner, another flag for admins (?). Should this also give permission to manage?
- make everything work with names containing spaces (except users: those should be checked not to have spaces) (?)
- client side completion engine (user list?)
