export PATH=~/bin:~/conf/bin:/usr/local/bin:$PATH
export CLICOLOR=1
#export LC_CTYPE=ru_RU.UTF-8

set -o vi

if [ -f /opt/local/etc/bash_completion ]; then
	. /opt/local/etc/bash_completion
fi

source `brew --prefix git`/etc/bash_completion.d/git-completion.bash

source ~/conf/bin/preexec.sh
preexec_install

PS1='\u@\h:\[\e[0;34m\]\W\[\e[m\]$(__git_ps1 " (\[\e[0;32m\]%s\[\e[m\])") \$ '
