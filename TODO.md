# TODO


## Improvements
- MOTD in interactive shell and `.hushlogin` in `install.sh`
- check for unnecessary arguments in commands (check arg number prior to executing the verbs)
- check when launching scripts that they run from the shell (so env variables are set) and/or set some fallback mechanism for when commands are not run by the shell
- write code documentation
- write user documentation
- implement conf limits (repo number, user number, etc.)
- user command: add rename verb

### Keys
- better check for ssh pubkey validity (not even `ssh-keygen -l` really works)
- avoid adding two keys with the same name
- avoid duplicate creation (the same for users and repos)

### "Security"
- text exploits like calling a key "GK_USER=blabla"
- make the code more secure to avoid argument injection (e.g. arguments containing `/`)

## Ideas
- various permissions for admins (e.g. add users but not delete them)
- config flag to make every repo accessible by the owner, another flag for admins (?). Should this also give permission to manage?
- migrate to `command` instead of `environment` in `authorized_keys` (and complete non-root compatibility)
- alphabetic storage of admins and users for access for binary search
- make everything work with names containing spaces (except users: those should be checked not to have spaces) (?)
