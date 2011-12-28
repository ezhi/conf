# variables
export PATH=~/bin:~/conf/bin:/usr/local/bin:$PATH
export PAGER=less
export EDITOR=vim

#export LC_CTYPE=ru_RU.UTF-8

# colors
export CLICOLOR=1
export LSCOLORS="ExGxFxdxCxDxDxhbadExEx"
alias grep='grep --color=auto'

# completion
export BASH_COMPLETION=~/conf/etc/bash_completion
export BASH_COMPLETION_DIR=~/conf/etc/bash_completion.d
export BASH_COMPLETION_COMPAT_DIR=~/conf/etc/bash_completion.d
source ~/conf/etc/bash_completion
source ~/conf/etc/git-completion.bash

# prompt
unset PROMPT_COMMAND
source ~/conf/etc/preexec.sh
preexec_install

PS1='\u@\h:\[\e[1;34m\]\W\[\e[m\]$(__git_ps1 " (\[\e[1;32m\]%s\[\e[m\])") \$ '

# readline
set -o vi

[ -f ~/.profile.local ] && source ~/.profile.local
