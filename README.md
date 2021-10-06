# GitKiss
GitKiss is a [SSH] [Git] server manager. It lets you create and organize users, repositories and more through SSH commands and a basic interactive shell. [KISS](https://en.wikipedia.org/wiki/KISS_principle) is the principle of Keep It Simple, Stupid.

[SSH]: https://en.wikipedia.org/wiki/Secure_Shell
[Git]: https://en.wikipedia.org/wiki/Git


## Motivation
Having a Git server is a big deal. And, by the way, you don't need an always-on server to have one. You can install GitKiss on your machine and just SSH into localhost. The purpose of GitKiss is providing something similar to [Gitolite] but with easier user/repo management.

[Gitolite]: https://gitolite.com



## Installation
Generate an SSH key pair. For example:
```sh
ssh-keygen -t ed25519 -f mykey
```

Make sure you have `sudo` access and run:
```sh
curl -O https://raw.githubusercontent.com/sgorblex/GitKiss/master/install.sh
chmod +x install.sh
./install.sh
```
Choose the owner's nickname and paste their public key (`mykey.pub`).

Make sure you have an SSH server running.


### Custom install
You may instead configure installation paths by using command line arguments as follows:
```sh
./install.sh --help
```
However, default values should generally be fine.

The server is entirely passive, meaning there are no daemons running, except for git-daemon, which is enabled by default on systemd and serves the public repositories. If you so desire you can disable it with `systemctl disable --now gitkiss-daemon.service`.



## Usage
Assuming you are using the default system user `gitkiss` and your server is `host`:
```sh
ssh -i mykey gitkiss@host help
```
lists available commands for your user. Substitute `help` with your desired command.

Alternatively (if the config doesn't disable it), just run
```sh
ssh -i mykey gitkiss@host
```
to start the interactive shell, where you can launch any command until you write `exit` or hit <kbd>CTRL</kbd><kbd>D</kbd>.


### TIPS
- add the host to `~/.ssh/config` for easier SSH commands (e.g. `ssh gk` instead of `ssh -i key gitkiss@host`). See manual page `ssh_config(5)`.
- add aliases within your shell to avoid writing long commands (e.g. `alias repo="ssh gitkiss repo"`)



## Features
- the `help` commands tells a user what commands they can run
- admins can manage users with the `user` command
- the owner can manage admins with the `admin` command
- all users can manage their repos with the `repo` command, including creating new repos, publishing them to `gitkiss-daemon`, setting permissions (`r`,`rw`) for other users and so on
- all users can manage their public keys with the `key` command



## Configuration
You may configure some aspects of the server by tweaking the file `GK_PATH/conf.sh`, which by default resides in `/srv/gitkiss/gitkiss/conf.sh`. The file is sourced by the GitKiss shell (so watch out to not break anything) and every customizable variable follows a brief description.



## Contribute
I like clean code! Make a pull request if you think some part can be better written (which is very possible) or if you think you have a killer feature upstream should have. Of course, filing [GitHub issues](https://github.com/sgorblex/GitKiss/issues) is a big help too.


### Code etiquette
- write POSIX compatible code (this includes using `printf` over `echo` in most cases)
- write with safe double quoting (`[ "$1" = "hello" ]` over `[ $1 = "hello" ]`)



## License
[GPL v.3](https://www.gnu.org/licenses/gpl-3.0.en.html)



## Similar software
- [Gitolite](https://gitolite.com)
- [Gogs](https://gogs.io)
- [GitLab](https://gitlab.com)
