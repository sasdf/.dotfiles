#!/bin/bash

set -euo pipefail

git_update () {
    local REPO="$1"
    local DEST="$2"
    if [ -d "$DEST" ]; then
        pushd "$DEST" >/dev/null
        git pull
        popd >/dev/null
    else
        git clone "$REPO" "$DEST"
    fi
}

yesno () {
    while true; do
        read -p "$1 [y/n] " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "[!] Please answer yes or no."; echo "";;
        esac
    done
}

cd "$HOME"

# Download dotfiles
echo "[*] Downloading dotfiles"
DOTS=${DOTS:-$HOME/.dotfiles}
git_update 'https://github.com/sasdf/.dotfiles.git' "$DOTS"

# Create dots setting
[ ! -e "$HOME/.dots" ] && cp "$DOTS/helpers/samples/dots" "$HOME/.dots"
if yesno "[?] Do you want to edit dots setting?"; then
    "${EDITOR:-vi}" "$HOME/.dots"
fi
source "$HOME/.dots"

# Create backup dir
BACKUP="$DOTSLO/.bak/$(date -Ins)"
mkdir -p "$BACKUP/"
ln_bak () {
    local SRC="$1"
    local DST="$2"
    if [ -e "$DST" ]; then
        DDST=`dirname "$DST"`
        mkdir -p "$BACKUP/$DDST"
        mv -f "$DST" "$BACKUP/$DDST"
        echo "Backup $DST"
    fi
    ln -rs "$SRC" "$DST"
}

mkdir -p "$DOTS_PATH_LOCAL" && chmod 700 "$DOTS_PATH_LOCAL"
mkdir -p "$DOTS_PATH_LOCAL_TMP" && chmod 700 "$DOTS_PATH_LOCAL_TMP"
mkdir -p "$HOME/.config"
mkdir -p "$HOME/bin"
mkdir -p "$DOTSLO" && chmod 700 "$DOTSLO"
mkdir -p "$DOTSLO/pkg"
mkdir -p "$DOTSLO/pkg/zsh-custom/plugins"
mkdir -p "$DOTSLO/pkg/zsh-custom/themes"

if yesno "[?] Do you want to install oh-my-zsh?"; then
    git_update 'https://github.com/ohmyzsh/ohmyzsh.git' "$DOTSLO/pkg/oh-my-zsh"
fi
if yesno "[?] Do you want to install zsh-autosuggestions?"; then
    git_update 'https://github.com/zsh-users/zsh-autosuggestions' "${DOTSLO}/pkg/zsh-custom/plugins/zsh-autosuggestions"
fi
if yesno "[?] Do you want to install zsh-completions?"; then
    git_update 'https://github.com/zsh-users/zsh-completions.git' "$DOTSLO/pkg/zsh-custom/plugins/zsh-completions"
fi
if yesno "[?] Do you want to install miniconda3?"; then
    tempdir=$(mktemp -d)
        curl -s https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh > "$tempdir/miniconda.sh"
        bash "$tempdir/miniconda.sh" -b -p "$DOTS_PATH_LOCAL/miniconda3"
    rm -rf "$tempdir"
fi

ln_bak  "$DOTS/zsh/custom/themes/dots.zsh-theme" "$DOTSLO/pkg/zsh-custom/themes/dots.zsh-theme"

ln_bak  "$DOTS/sh/profile"      ".profile"
ln_bak  "$DOTS/sh/shrc"         ".shrc"
ln_bak  "$DOTS/sh/profile"      ".bash_profile"
ln_bak  "$DOTS/sh/shrc"         ".bashrc"
ln_bak  "$DOTS/zsh/zprofile"    ".zprofile"
ln_bak  "$DOTS/zsh/zshrc"       ".zshrc"
ln_bak  "$DOTS/tmux/tmux.conf"  ".tmux.conf"
ln_bak  "$DOTS/conda/condarc"   ".condarc"
ln_bak  "$DOTS/kak"             ".config/kak"
ln_bak  "$DOTS/kak-lsp"         ".config/kak-lsp"
