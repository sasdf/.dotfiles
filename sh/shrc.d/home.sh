# .--------------.
# | Expand $HOME |
# '--------------'

if [ ! -z "$HOME" ]; then
    export REALHOME=$(realpath "$HOME")
    export REALPWD=$(realpath "$PWD")
    if [ "$REALPWD" = "$REALHOME" ]; then
        cd "$REALHOME"
    fi
    export HOME=$REALHOME
fi
