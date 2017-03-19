
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## NB the above is usually the default content of .bashrc in e.g. /etc/skel/

###### CUSTOMIZATIONS ##########################################################

#
# HISTORY
# See:
# + https://wiki.archlinux.org/index.php/Bash
# + https://wiki.archlinux.org/index.php/Readline#History

# don't put duplicate lines in the history and ignore lines starting with
# a space
export HISTCONTROL=ignoreboth

# history completion bound to arrow keys (down, up)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'


#
# ENHANCEMENTS
# See
# + https://wiki.archlinux.org/index.php/Bash

# Display error codes
# set trap to intercept the non-zero return code of last program:
EC() { echo -e '\e[1;33m'code $?'\e[m\n'; }
trap EC ERR

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"


#
# APPEARANCE
# See:
# + https://wiki.archlinux.org/index.php/Bash
# + https://wiki.archlinux.org/index.php/Color_Bash_Prompt

# Colorize output of ls and grep.
alias ls='ls --color=auto'
export GREP_COLOR="1;34"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

eval `dircolors -b`


# Simple prompt.
PS1='\$ '
export PROMPT_COMMAND=''
