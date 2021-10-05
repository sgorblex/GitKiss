# TODO


## Improvements
- add file inclusion check (as in C header files)
- check for unnecessary arguments in commands (check arg number prior to executing the verbs)
- check when launching scripts that they run from the shell (so env variables are set) and/or set some fallback mechanism for when commands are not run by the shell
- write code documentation
- write user documentation
- user command: add rename verb (?)
- configuration validity check
- ditch `isIn` (?)

### "Security"
- text exploits like calling a key "GK_USER=blabla"
- make the code more secure to avoid argument injection (e.g. arguments containing `/`)

## Ideas
- up arrow key for last command in interactive shell
- various permissions for admins (e.g. add users but not delete them, manage pubkeys, etc.)
- config flag to make every repo accessible by the owner, another flag for admins (?). Should this also give permission to manage?
- migrate to `command` instead of `environment` in `authorized_keys` (and complete non-root compatibility)
- alphabetic storage of admins and users for access with binary search
- make everything work with names containing spaces (except users: those should be checked not to have spaces) (?)
- client side completion engine (user list?)
