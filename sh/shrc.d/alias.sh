# .------------------.
# | Standard Aliases |
# '------------------'

alias less='less -R'
alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'
alias dir='ls -lg|more'
alias cls='clear'
alias telnet='telnet -8'
alias grep='egrep'
alias talk='ytalk'
alias gdb='LC_ALL=en_US.UTF8 gdb'

os=${OSTYPE/[^a-z]*/}
case "$os" in
"freebsd")
    alias ls='ls -FG'
    export LSCOLORS='ExGxFxdxCxDxDxhbadacad'
    ;;
"linux")
    alias ls='ls --color -F'
    ;;
"solaris")
    alias ls='ls --color --show-control-chars -F'
    alias ping="ping -s"
    ;;
esac
