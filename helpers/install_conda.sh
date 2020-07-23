set -euo pipefail

echo "[*] Install miniconda3 to $DOTS_PATH_LOCAL/miniconda3"

tempdir=$(mktemp -d)
    curl -s 'https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh' > "$tempdir/miniconda.sh"
    bash "$tempdir/miniconda.sh" -b -p "$DOTS_PATH_LOCAL/miniconda3"
rm -rf "$tempdir"
