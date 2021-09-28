# TODO


## Improvements
- check when launching scripts that they run from the shell (so env variables are set) and/or
- set some fallback mechanism for when commands are not run by the shell
- check for unnecessary arguments in commands (check arg number prior to executing the verbs)
- alphabetic storage of admins and users for access for binary search (?)
- make everything work with names containing spaces (except users: those should be checked not to have spaces)
- substitute `if [ ! -d "$repo_path" ]` with a library function `isRepo(user, reponame)`
- implement repo limits
- write way better code
- write code documentation
- write user documentation
- implement the rest of repo ls
- make the code more secure to avoid argument injection (e.g. arguments containing `/`)
- add to the pubKeys lib the string `no-port-forwarding,no-X11-forwarding,no-agent-forwarding,environment=` and adapt commands

### Keys
- better check for ssh pubkey validity (not even `ssh-keygen -l` really works)
- text exploits like calling a key "GK_USER=blabla"
- fix multiple words key names
- avoid adding two keys with the same names


## Ideas
- various permissions for admins (e.g. add users but not delete them)
- config flag to make every repo accessible by the owner, another flag for admins (?). Should this also give permission to manage?
