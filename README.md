## Configure
```
# ~/.dots
# --------

# This file should contain machine dependent environment variables.


# .-----------------------.
# | Set dotfiles basepath |
# '-----------------------'

export DOTS="$HOME/.dotfiles"
export DOTSLO="$HOME/.dotfiles-local"


# .---------------------------.
# | Package installation path |
# '---------------------------'

# local storage
export DOTS_PATH_LOCAL="/tmp2/$USER/local"
export DOTS_PATH_LOCAL_TMP="/tmp2/$USER"
export DOTS_LOCAL_SYNC_SERVER="oasis2"

# dotsfiles-local
export DOTS_PATH_KAKOUNE="$DOTSLO/pkg/kakoune"
export DOTS_PATH_OH_MY_ZSH="$DOTSLO/pkg/oh-my-zsh"
export DOTS_PATH_ZSH_CUSTOM="$DOTSLO/pkg/zsh-custom"
```
