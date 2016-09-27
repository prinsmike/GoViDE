# .bashrc

[ -z "$PS1" ] && return

alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -lhSrta'
alias l='ls -CF'
alias lt='ls -lrt'
alias grep='grep --color-auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias cnt='ls -l ./|grep -v ^1|wc -l'

if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -f /usr/share/bash-completion/bash_completion ] && ! shopt -oq posix; then
	. /usr/share/bash-completion/bash_completion
fi

export GOPATH='/go'
export PATH="$PATH:$GOPATH/bin"

