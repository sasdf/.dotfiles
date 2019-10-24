# .--------------.
# | Expand $HOME |
# '--------------'

if [ ! -z "$HOME" ]; then
    export REALHOME=$(/bin/realpath "$HOME")
    export REALPWD=$(/bin/realpath "$PWD")
    if [ "$REALPWD" = "$REALHOME" ]; then
        cd "$REALHOME"
    fi
    export HOME=$REALHOME
fi
