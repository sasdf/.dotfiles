# .-----------.
# | User PATH |
# '-----------'

# don't include current path
# home binaries
export PATH="$HOME/bin"
export LD_LIBRARY_PATH="$HOME/lib"

# kakoune
if [ ! -z "$DOTS_PATH_KAKOUNE" ]; then
    export PATH="$PATH:$DOTS_PATH_KAKOUNE/bin"
fi

# ruby
# export PATH="$PATH:$HOME/.gem/ruby/2.4.0/bin"

# yarn
# export PATH="$PATH:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin"


# .---------------.
# | Local storage |
# '---------------'

if [ ! -z "$DOTS_PATH_LOCAL" ]; then
    # local storage tools
    export PATH="$PATH:$DOTS/local-storage/bin"

    # bin
    export PATH="$PATH:$DOTS_PATH_LOCAL/bin:$DOTS_PATH_LOCAL/.local/bin"

    # conda
    export PATH="$PATH:$DOTS_PATH_LOCAL/miniconda3/bin"

    # npm
    export PATH="$PATH:$DOTS_PATH_LOCAL/npm/node_modules/.bin"

    # rust
    export PATH="$PATH:$DOTS_PATH_LOCAL/rust/cargo/bin"

    # golang
    export PATH="$PATH:$DOTS_PATH_LOCAL/go/bin"

    # lib
    export LD_LIBRARY_PATH="$DOTS_PATH_LOCAL/lib"
fi


# .-------------.
# | System PATH |
# '-------------'

export PATH="$PATH:/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/bin:/usr/local/sbin:/usr/X11R6/bin"
