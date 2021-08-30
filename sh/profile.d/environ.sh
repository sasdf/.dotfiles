# .----------------.
# | Common Environ |
# '----------------'

# export LC_ALL=zh_TW.UTF-8
export ENV="$DOTS/sh/shrc"
export USER=$LOGNAME
export IGNOREEOF=23
export BLOCKSIZE=1k

# less
export PAGER=less
export LESSCHARDEF=8bcccbcc18b.   # Used for command less
export LESS="-srPm-LESS-"

# kakoune
export EDITOR=kak
export VISUAL=kak
export KAKOUNE_POSIX_SHELL="/bin/bash"

# TERM
if [ -z "$TMUX" ] && [ -z "$TERM" ]; then
    export TERM=xterm-256color
fi


# .---------------.
# | Local storage |
# '---------------'

if [ ! -z "$DOTS_PATH_LOCAL" ]; then
    # python pip
    export PYTHONUSERBASE="$DOTS_PATH_LOCAL/.local"

    # rust
    export CARGO_HOME="$DOTS_PATH_LOCAL/rust/cargo/"
    export RUSTUP_HOME="$DOTS_PATH_LOCAL/rust/rustup/"

    # golang
    export GOPATH="$DOTS_PATH_LOCAL/go/"
fi

if [ ! -z "$DOTS_PATH_LOCAL_TMP" ]; then
    # c / c++
    export CCACHE_DIR="$DOTS_PATH_LOCAL_TMP/cache/.ccache"
fi
