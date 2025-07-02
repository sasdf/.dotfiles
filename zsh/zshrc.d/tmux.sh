tmux_auto_refresh() {
  if [[ "${TMUX_REFRESH}" != "n" ]]; then
    local mux=${HOSTMUX:-$TMUX}
    if [[ -n "${mux}" ]]; then
      eval "$(TMUX="${mux}" tmux show-environment -s)"
    fi
  fi
}

autoload -U add-zsh-hook
add-zsh-hook preexec tmux_auto_refresh
