#   ____ _ _   _  ___         
#  / ___(_) |_| |/ (_)___ ___ 
# | |  _| | __| ' /| / __/ __|
# | |_| | | |_| . \| \__ \__ \
#  \____|_|\__|_|\_\_|___/___/

# GitKiss server configuration
# Tweak here your GitKiss server

# (this file is meant to be sourced by the GitKiss shell at each user access, so be aware if you add scripting)

# $GK_PATH is the path of the GitKiss repository (it is automatically set)




# server owner (GitKiss user, not os user)
GK_OWNER="sgorblex"



# REPOSITORIES

# path of the stored repositories
GK_REPO_PATH="$HOME/repositories"

# maximum number of repositories per user
GK_MAX_REPOS=99

# path of the repositories of deleted users (leave blank for no archive)
GK_ARCHIVE_PATH="$GK_PATH/archived"



# INTERACTIVE SHELL

# active (true/false)
GK_INTERACTIVE=true

# normal prompt
GK_PROMPT="\nGitKiss > "

# prompt when previous command exited with error
GK_ERR_PROMPT="\nGitKiss :( > "



# USERS

# maximum number of users
GK_MAX_USERS=30



# SSH KEYS

# authorized_keys path (leave default if not sure)
GK_AUTHORIZED_KEYS="$HOME/.ssh/authorized_keys"

# maximum number of keys per user
GK_MAX_KEYS=10



# INSTANCE FILES

# list of existing users
GK_USERLIST="$GK_PATH/users"

# list of existing admins
GK_ADMINLIST="$GK_PATH/admins"





# exporting set configuration
export GK_OWNER
export GK_REPO_PATH
export GK_MAX_REPOS
export GK_ARCHIVE_PATH
export GK_INTERACTIVE
export GK_PROMPT
export GK_ERR_PROMPT
export GK_MAX_USERS
export GK_AUTHORIZED_KEYS
export GK_MAX_KEYS
export GK_USERLIST
export GK_ADMINLIST
