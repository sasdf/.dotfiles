# .------------------.
# | Conda initialize |
# '------------------'

if [ ! -z "$DOTS_PATH_CONDA" ] && [ -e "$DOTS_PATH_CONDA" ]; then
    __conda_setup="$($DOTS_PATH_CONDA/bin/conda 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$DOTS_PATH_CONDA/etc/profile.d/conda.sh" ]; then
            . "$DOTS_PATH_CONDA/etc/profile.d/conda.sh"
        else
            export PATH="$DOTS_PATH_CONDA/bin:$PATH"
        fi
    fi
    unset __conda_setup
fi
