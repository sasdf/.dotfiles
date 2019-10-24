# .------------------.
# | List tmux/screen |
# '------------------'

if [ "$(screen -ls 2>/dev/null | wc -l)" -gt 2 ]; then
    echo ""
    echo "There're screens detached! please use 'screen -r'."
    echo ""
fi

tmux ls 2>/dev/null

return 0
