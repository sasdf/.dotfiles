git clone https://github.com/robbyrussell/oh-my-zsh.git ${DOTS}/.pkg/oh-my-zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ${DOTS}/.pkg/zsh-plugins/zsh-autosuggestions

tempdir=$(mktemp -d)
    curl -s https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh > "$tempdir/miniconda.sh"
    bash "$tempdir/miniconda.sh" -b -p "$HOME/local/miniconda3"
rm -rf "$tempdir"
