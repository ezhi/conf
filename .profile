export PATH=~/bin:~/conf/bin:/usr/local/bin:$PATH

#export LC_CTYPE=ru_RU.UTF-8

# colors
export CLICOLOR=1
export LSCOLORS="ExGxFxdxCxDxDxhbadExEx"
alias grep='grep --color=auto'

# completion
if [ -f /opt/local/etc/bash_completion ]; then
	. /opt/local/etc/bash_completion
fi

source `brew --prefix git`/etc/bash_completion.d/git-completion.bash

# prompt

source ~/conf/bin/preexec.sh
preexec_install

PS1='\u@\h:\[\e[1;34m\]\W\[\e[m\]$(__git_ps1 " (\[\e[1;32m\]%s\[\e[m\])") \$ '

set -o vi
