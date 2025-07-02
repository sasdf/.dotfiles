tmux_auto_refresh() {
  if [[ "${TMUX_REFRESH}" != "n" ]]; then
    eval "$(tmux show-environment -s)"
  fi
}

autoload -U add-zsh-hook
add-zsh-hook preexec tmux_auto_refresh
