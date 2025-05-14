# .---------------------.
# | Tmux Environ helper |
# '---------------------'

if [ -n "$TMUX" ]; then
    export HOSTMUX="$TMUX"
    if [[ "$TMUX" =~ "hostmux" ]]; then
        unset TMUX
    fi

    function refresh_var () {
        NEWENVVAR=$(TMUX="$HOSTMUX" tmux show-environment | grep "^$1=")
        if [ -n "$NEWENVVAR" ]; then
            echo "$1 updated"
            export $NEWENVVAR
        fi
    }
    function refresh () {
        refresh_var "SSH_AUTH_SOCK"
        refresh_var "DISPLAY"
    }
else
    function refresh () {
        echo "Not inside tmux"
    }
fi
