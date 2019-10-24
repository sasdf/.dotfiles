# .--------------.
# | Prompt Style |
# '--------------'

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

parse_conda_env() {
    if [ ! -z "$CONDA_DEFAULT_ENV" ] && [ "$CONDA_DEFAULT_ENV" != "base" ]; then
        echo " ($CONDA_DEFAULT_ENV)"
    fi
}

if [ "$ASCIINEMA_REC" = "1" ] && [ "$ASCIINEMA_PS1" = "" ]; then
    export PS1="$ "
    export PS2="> "
else
    export PS1="\n"
    if [ -n "$TMUX" ]; then
        export PS1="$PS1\[\033[32;1m\] \$ \w"
    else
        export PS1="$PS1\[\033[32;1m\] \u@\h\$ \w"
    fi
    export PS1="$PS1\[\033[35m\]\$(parse_conda_env)"
    export PS1="$PS1\[\033[33m\]\$(parse_git_branch)"
    export PS1="$PS1\n"
    export PS1="$PS1\[\033[36;1m\].. \[\033[0m\]"
    export PS2='\[\033[33;1m\].. \[\033[0m\]'
fi
