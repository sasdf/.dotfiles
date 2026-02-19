# kakoune configuration


# Plugins
# ───────
evaluate-commands %sh{
    autoload_directory() {
        find -L "$1" -type f -name '*\.kak' \
            | sed 's/.*/try %{ source "&" } catch %{ echo -debug Autoload: could not load "&" }/'
    }
    autoload_directory ${kak_config}/plugins
}


# User interface
# ──────────────
colorscheme tomorrow-night
# add-highlighter global/ number-lines -relative -hlcursor -separator '  '
add-highlighter global/ number-lines -hlcursor -separator '  '
add-highlighter global/ wrap


# Goodbye, CLIPPY
# ───────────────
set-option global ui_options ncurses_assistant=none
set-option global ui_options terminal_assistant=none


# Avoid closing accidentally
# ──────────────────────────
alias global qu quit
alias global qu! quit!
unalias global q
unalias global q!
define-command -override -hidden q 'echo Use :qu to quit'
alias global q! q


# Commenter
# ─────────
map global normal '#' ': comment-line<ret>'


# Map jk to esc
# ─────────
hook global InsertChar k %{ try %{
    exec -draft hH <a-k>jk<ret> d
    exec <esc>
}}
hook global InsertChar j %{ try %{
    exec -draft hH <a-k>kj<ret> d
    exec <esc>
}}


# Use Ctrl-t to go up menu ( dvorak layout )
map global insert <c-t> <c-p>
map global normal <c-t> <c-p>



# CamelCase movement
# ──────────────────
define-command -hidden select-prev-word-part %{
  # Reverse search and ignore spaces
  exec <a-/>
  # Non-words and digits
  exec [^0-9A-Za-z\s]|[0-9]+|
  # lowercase
  exec ((?<lt>![A-Za-z])|(?<lt>=[A-Z][A-Z]))[a-z]+|
  # CamelCase and UPPERCASE
  exec (?<lt>![A-Z])[A-Z]([a-z]+|[A-Z]+|(?![A-Za-z]))
  # Execute
  exec <ret>
}
define-command -hidden select-next-word-part %{
  # Forward search and ignore spaces
  exec /
  # Non-words and digits
  exec [^0-9A-Za-z\s]|[0-9]+|
  # lowercase
  exec [a-z]+|
  # CamelCase and UPPERCASE
  exec [A-Z]([a-z]+|[A-Z]+|(?![A-Za-z]))
  # Execute
  exec <ret>
}
define-command -hidden extend-prev-word-part %{
  # Reverse search and ignore spaces
  exec <a-?>
  # Non-words and digits
  exec [^0-9A-Za-z\s]|[0-9]+|
  # lowercase
  exec ((?<lt>![A-Za-z])|(?<lt>=[A-Z][A-Z]))[a-z]+|
  # CamelCase and UPPERCASE
  exec (?<lt>![A-Z])[A-Z]([a-z]+|[A-Z]+|(?![A-Za-z]))
  # Execute
  exec <ret>
}
define-command -hidden extend-next-word-part %{
  # Forward search
  exec ?
  # Non-words and digits
  exec [^0-9A-Za-z\s]|[0-9]+|
  # lowercase
  exec [a-z]+|
  # CamelCase and UPPERCASE
  exec [A-Z]([a-z]+|[A-Z]+|(?![A-Za-z]))
  # Execute
  exec <ret>
}
map global normal w :select-next-word-part<ret>
map global normal W :extend-next-word-part<ret>
map global normal b :select-prev-word-part<ret>
map global normal B :extend-prev-word-part<ret>


# Select Lines
# ───────────
define-command -hidden -params 1 extend-line-down %{
  try %{
      exec -draft s^.*$<ret>
      exec %arg{1}J
  }
  exec x
}
define-command -hidden -params 1 extend-line-up %{
  try %{
      exec -draft s^.*$<ret>
      exec %arg{1}K
  }
  exec x
}
map global normal x ':extend-line-down %val{count}<ret>'
map global normal X ':extend-line-up %val{count}<ret>'


# Highlight the word under the cursor
# ───────────────────────────────────
declare-option -hidden regex curword

hook global NormalIdle .* %{
    eval -draft %{ try %{
        exec ,<a-i>w <a-k>\A[\w\-]+\z<ret>
        exec -draft "/%val{selection}.*?%val{selection}<ret>"
        set-option buffer curword "\b\Q%val{selection}\E\b"
    } catch %{
        set-option buffer curword ''
    } }
}
add-highlighter global/ dynregex '%opt{curword}' 0:CurWord
set-face global CurWord default,rgb:000000


# Clear search pattern
# ────────────────────
map global user -docstring 'clear search pattern' c ':set-register "/" ""<ret><c-l>'


# Highlight matches
# ─────────────────
add-highlighter global/ show-matching
add-highlighter global/ dynregex '%reg{/}' 0:+u


# System clipboard handling
# ─────────────────────────
eval %sh{
    case $(uname) in
        Linux) copy="xclip -i"; paste="xclip -o" ;;
        Darwin)  copy="pbcopy"; paste="pbpaste" ;;
    esac

    printf "map global user -docstring 'paste (after) from clipboard' p '!%s<ret>'\n" "$paste"
    printf "map global user -docstring 'paste (before) from clipboard' P '<a-!>%s<ret>'\n" "$paste"
    printf "map global user -docstring 'yank to clipboard' y '<a-|>%s<ret>:echo -markup %%{{Information}copied selection to X11 clipboard}<ret>'\n" "$copy"
    printf "map global user -docstring 'replace from clipboard' R '|%s<ret>'\n" "$paste"
}


# Auto-completion Language Server
# ─────────────────────────
define-command -hidden enable-kak-lsp %{
    lsp-enable-window
    # Replace lsp-start with following commad to debug
    # nop %sh{ (kak-lsp -s $kak_session -vvv) > /tmp/kak-lsp.log 2>&1 < /dev/null & }
    lsp-auto-signature-help-enable
}

define-command -hidden start-kak-lsp-callback %{
    lsp-stop-on-exit-enable
    map global user -docstring 'Enable lsp' l ':enable-kak-lsp<ret>'
    map global user -docstring 'Enable lsp auto hover' d ':lsp-auto-hover-enable<ret>'
    map global user -docstring 'Disable lsp auto hover' D ':lsp-auto-hover-disable<ret>'
    map global user -docstring 'Hover lsp information' h ':lsp-hover<ret>'
    map global goto -docstring 'diagnostics' D ':lsp-diagnostics<ret>'
    map global goto -docstring 'references' r ':lsp-references<ret>'
}

eval %sh{
    kak-lsp --kakoune -s $kak_session && \
    echo "start-kak-lsp-callback"
}


# Indent
# ──────
# map global insert <tab> '<a-;><a-gt>'
map global insert <s-tab> '<a-;><lt>'
declare-option bool expandtab true
hook global InsertChar \t %{ try %{
    execute-keys -draft %sh{
        if [ "$kak_opt_expandtab" == "true" ]; then
            printf ';<a-;><a-gt>hd'
        fi
    }
}}
hook global InsertDelete ' ' %{ try %{
    execute-keys -draft 'h<a-h><a-k>\A\h+\z<ret>i<space><esc><lt>'
}}
define-command -params 2 -docstring 'set-indent <scope> <width>' set-indent %{
    evaluate-commands %sh{
        if ! [ "${2}" -eq "${2}" ]; then
            printf "%s\n" 'echo "Error: indent should be zero (disable) or a positive number"'
            exit
        fi
        if [ "${2}" -gt "0" ]; then
            printf "%s\n" 'set-option %arg{1} expandtab true'
            printf "%s\n" 'set-option %arg{1} indentwidth %arg{2}'
            printf "%s\n" 'echo "Set %arg{1} indent width to %arg{2}"'
        elif [ "${2}" -eq "0" ]; then
            printf "%s\n" 'set-option %arg{1} expandtab false'
            printf "%s\n" 'set-option %arg{1} indentwidth %arg{2}'
            printf "%s\n" 'echo Disable %arg{1} indent'
        elif [ "${2}" -lt "0" ]; then
            printf "%s\n" 'echo "Error: indent should be zero (disable) or a positive number"'
        fi
    }
}
map global user -docstring 'set buffer indent' i %{:prompt indent: 'set-indent buffer %val{text}'<ret>}
map global user -docstring 'set global indent' I %{:prompt indent: 'set-indent global %val{text}'<ret>}


# Buffer
# ──────
hook global WinDisplay .* bufs-update

declare-user-mode bufs
def bufs-update -docstring 'populate an selection UI with a numbered buffers list' %{
  refresh-buffers-info
  evaluate-commands %sh{
    # find offset
    eval "set -- $kak_quoted_opt_buffers_info"
    offset=-4
    while [ "$1" ]; do
      name=${1%_*}
      if [ "$name" = "$kak_bufname" ]; then
        break
      fi
      offset=$(($offset + 1))
      shift
    done

    # shift list
    eval "set -- $kak_quoted_opt_buffers_info"
    offset=$(($#-$offset<10?$#-10:$offset))
    while [ "$offset" -gt "0" ]; do
        offset=$(($offset - 1))
        shift
    done

    # clear empty entries
    if [ "$#" -lt "10" ]; then
        index="$#"
        while [ "$index" -le "10" ]; do
          printf "unmap global bufs %s\n" "$(($index % 10))"
          index=$(($index + 1))
        done
    fi

    # render buffer entries
    index=1
    while [ "$1" ] && [ "$index" -le "10" ]; do
      idx=$(($index % 10))
      name=${1%_*}
      sname="${name//\'/\'\'}"
      if [ "$name" = "$kak_bufname" ]; then
        printf "map global bufs %s ':buffer %s<ret>' -docstring '> %s" "$idx" "$sname" "$sname"
      elif [ "$name" = "$kak_opt_alt_bufname" ]; then
        printf "map global bufs %s ':buffer %s<ret>' -docstring '* %s" "$idx" "$sname" "$sname"
      else
        printf "map global bufs %s ':buffer %s<ret>' -docstring '- %s" "$idx" "$sname" "$sname"
      fi

      modified=${1##*_}
      if [ "$modified" = true ]; then
        printf " [+]"
      fi
      printf "'\n"

      index=$(($index + 1))
      shift
    done
  }
}
define-command -docstring 'Open file similar to bufname' buffer-bufname %{
  # execute-keys ":edit %val{bufname}"
  prompt -file-completion 'edit:' -init "%val{buffile}" %{
      edit "%val{text}"
      bufs-enter
  }
}
define-command -docstring 'Open BUILD file in this directory' buffer-BUILD %{
  evaluate-commands %sh{
    eval set -- "$kak_quoted_buffile"
    file="$(dirname "$1")/BUILD"
    if [[ -f "$file" ]]; then
      file="${file/\'/\'\'}"
      printf "edit '%s'\n" "$file"
    else
      printf "echo 'BUILD file not found'\n"
    fi
  }
}
define-command buffer-readonly -docstring 'reopen current file as readonly' %{
  edit -readonly "%val{buffile}"
}

define-command bufs-enter -hidden -docstring 'enter bufs user-mode' %{
  bufs-update
  enter-user-mode bufs
}

define-command bufs-cmd -hidden -docstring 'evaluate bufs subcommand' -params 1 %{
  try %{
    evaluate-commands "%arg{1}"
  }
  bufs-enter
}

map global bufs -docstring 'swap'    'a' ':bufs-cmd "exec ga"<ret>'
map global bufs -docstring 'prev'    't' ':bufs-cmd "buffer-previous"<ret>' # Dvorak
map global bufs -docstring 'next'    'n' ':bufs-cmd "buffer-next"<ret>'
map global bufs -docstring 'open'    'o' ':bufs-cmd "fzf-file"<ret>'
map global bufs -docstring 'find'    'f' ':bufs-cmd "fzf-buffer"<ret>'
map global bufs -docstring 'grep'    'g' ':fzf-grep<ret>'
map global bufs -docstring 'edit'    'e' ':buffer-bufname<ret>'
map global bufs -docstring 'BUILD'   'b' ':bufs-cmd "buffer-BUILD"<ret>'
map global bufs -docstring 'scratch' 'c' ':bufs-cmd "edit -scratch"<ret>'
map global bufs -docstring 'debug'   '!' ':bufs-cmd "edit *debug*"<ret>'
map global bufs -docstring ' '       ' ' ''
map global normal -docstring 'show buffer list' -- '-' ':bufs-enter<ret>'


# FZF
# ───
define-command -params ..1 -docstring 'Invoke fzf to open a file' fzf-file %{
    evaluate-commands %sh{
        if [ -z "${kak_client_env_TMUX}" ]; then
            printf 'fail "client was not started under tmux"\n'
        else
            dir="${1:-.}"
            file=$(
                cd "$dir" &&
                rg -L --hidden --files -0 |
                TMUX="${kak_client_env_TMUX}" fzf-tmux \
                    --read0 \
                    -d 80% \
                    --preview " \
                        bat --color=always \
                            --style=header,grid,numbers \
                            {} | \
                        head -n 40" \
                    --preview-window=right \
            )
            if [ -n "$file" ]; then
                file="$dir/$file"
                file="${file/\'/\'\'}"
                printf "edit '%s'\n" "$file"
            else
                printf 'fail "no file selected"'
            fi
        fi
    }
}

define-command -docstring 'Invoke fzf to search a file' fzf-grep %{
    prompt 'search' %{
        fzf-grep-impl
        bufs-enter
    }
}

define-command -hidden fzf-grep-impl %{
    evaluate-commands %sh{
        if [ -z "${kak_client_env_TMUX}" ]; then
            printf 'fail "client was not started under tmux"\n'
        else
            quoted=$(printf "%q" "$kak_text")
            file=$(
                rg -L --hidden -0 -l "$kak_text" < /dev/null | \
                TMUX="${kak_client_env_TMUX}" fzf-tmux \
                    --read0 \
                    -d 80% \
                    --preview "\
                        rg $quoted \
                            -A 2 -B 2 \
                            --color=always \
                            {} | \
                        head -n 80" \
                    --preview-window=right \
            )
            if [ -n "$file" ]; then
                file=${file/\'/\'\'}
                printf "edit '%s'\n" "$file"
            fi
        fi
    }
}

define-command -docstring 'Invoke fzf to select a buffer' fzf-buffer %{
    evaluate-commands %sh{
        BUFFER=$(
            (
                eval "set -- $kak_buflist"
                while [ $# -gt 0 ]; do
                    printf "%s\0" "$1"
                    shift
                done
            ) |
            fzf-tmux -d 80% --read0
        )
        BUFFER=${BUFFER/\'/\'\'}
        if [ -n "$BUFFER" ]; then
            printf "buffer '%s'" "${BUFFER}"
        fi
    }
}


# Better replace command
# ──────────────────────
map global normal -docstring 'replace left hand side character' r '<a-:><a-;>;r'
map global normal -docstring 'replace right hand side character' <a-r> '<a-:>;r'
map global normal -docstring 'replace whole selection' <c-r> 'r'


# Clear Main selection
# ────────────────────
map global normal -docstring 'remove main selection' "'" '<a-,>'
map global normal -docstring 'remove main selection' "<space>" ','
map global normal -docstring 'remove main selection' "," '<space>'


# Set filetype
# ────────────
define-command -docstring 'Prompt for setting filetype' set-filetype %{
    prompt filetype: 'set-option buffer filetype %val{text}'
}
map global user -docstring 'set filetype' f ':set-filetype<ret>'


# GenAI Integration
# ──────────────────
define-command -params 1 -docstring 'Inline text' inline-text %{
  evaluate-commands -draft -no-hooks %{
    execute-keys -draft "!cat '%arg{1}'<ret>"
  }
}
define-command -params 1 -docstring 'Inline text (replace)' replace-text %{
  evaluate-commands -draft -save-regs '"' -no-hooks %{
    execute-keys -draft "d!cat '%arg{1}'<ret>"
  }
}
define-command -params 1 -docstring 'Inline text (append)' append-text %{
  evaluate-commands -draft -no-hooks %{
    execute-keys -draft "<a-!>cat '%arg{1}'<ret>"
  }
}
declare-option -docstring 'Include all files in context' bool genai_all_files false
declare-option -docstring 'Run kaka from golang source' bool genai_debug_build false
declare-option -docstring 'Last genai command' str-list genai_last_command ""
define-command -params 1.. -docstring 'Chat with GenAI' genai %{
  set-option global genai_last_command %arg{@}
  # Wrap in evaluate-commands to group undo history
  evaluate-commands %{
    execute-keys '<a-:>'
    nop -- %sh{
      KAKA="kaka"

      ARGS=()

      if [[ "$kak_opt_genai_all_files" == "true" ]]; then
        ARGS+=(
          --all-files
        )
      fi

      if [[ "$kak_opt_genai_debug_build" == "true" ]]; then
        KAKA="go run kaka.go"
      fi

      $KAKA \
        --cmd_fifo "$kak_command_fifo" \
        --res_fifo "$kak_response_fifo" \
        "${ARGS[@]}" \
        "$@"
    }
  }
}

define-command -docstring 'Start conversation with AI' genai-start-conv %{
  execute-keys "\\o"
  execute-keys "{<ret>"
  execute-keys "=== GenAI Conversation Start ===<ret>"
  execute-keys "<ret>"
  execute-keys "<lt>[User]<gt>:<ret>"
  execute-keys "<ret>"
  execute-keys "=== GenAI Conversation End ===<ret>"
  execute-keys "}"
  execute-keys "<esc>3kA <esc>"
}

define-command -docstring 'Set file context mode' -params 1 genai-set-context %{
  evaluate-commands %sh{
    if [[ "${1}" == "true" ]]; then
      echo "set-option global genai_all_files true"
      echo "map global genai -docstring 'Context: all files' c ':genai-toggle-context<ret>'"
    else
      echo "set-option global genai_all_files false"
      echo "map global genai -docstring 'Context: current file' c ':genai-toggle-context<ret>'"
    fi
  }
}

define-command -docstring 'Toggle file context mode' genai-toggle-context %{
  evaluate-commands %sh{
    if [[ "$kak_opt_genai_all_files" == "false" ]]; then
      echo "genai-set-context true"
    else
      echo "genai-set-context false"
    fi
  }
}

define-command -docstring 'Auto mode with custom prompt' -params 1 genai-prompt %{
  prompt "genai (%arg{1}):" %{
    genai "%arg{1}" --instr "%val{text}"
  }
}

declare-option -docstring 'Path to the directory containing prompt files' \
    str genai_prompts_dir "%sh{ echo $HOME/.config/prompts/ }"

define-command -hidden genai-open-prompts -docstring 'Open a prompt file' %{
  evaluate-commands %sh{
    if [ -z "$kak_opt_genai_prompts_dir" ]; then
      printf "fail 'genai_prompts_dir is not set'\n"
    elif [ ! -e "$kak_opt_genai_prompts_dir" ]; then
      printf "fail 'genai_prompts_dir directory does not exist'\n"
    elif [ ! -d "$kak_opt_genai_prompts_dir" ]; then
      printf "fail 'genai_prompts_dir is not a directory'\n"
    fi
  }
  fzf-file %opt{genai_prompts_dir}
  edit -scratch *prompt*
  delete-buffer!
  rename-buffer -scratch *prompt*
  execute-keys "gj"
}

define-command -hidden genai-repeat -docstring 'Repeat the last genai command' -params ..1 %{
  evaluate-commands %sh{
    if [ -z "$kak_opt_genai_last_command" ]; then
      printf "fail 'genai_last_command is not set'\n"
      exit 0
    fi

    if [ "$1" = "--retry" ]; then
      printf "try %%{execute-keys 'u'}\n"
    fi
    printf "genai %%opt{genai_last_command}\n"
  }
}

declare-user-mode genai
map global genai -docstring 'Context Mode' c ':genai-toggle-context<ret>'
map global genai -docstring 'Retry' u ':genai-repeat --retry<ret>'
map global genai -docstring 'Repeat' . ':genai-repeat<ret>'
map global genai -docstring 'Magic GenAI' a ':genai auto<ret>'
map global genai -docstring 'Magic GenAI' <c-a> ':genai auto<ret>'
map global genai -docstring 'Grammar' g ':genai auto --instr "Correct grammar of the selected part"<ret>'
map global genai -docstring 'Rephrase' r ':genai auto --instr "Rephrase the selected part"<ret>'
map global genai -docstring 'Edit config' e ':e ~/.config/kaka/kaka.yml<ret>'
map global genai -docstring 'Custom prompt' t ':genai-prompt auto<ret>'
map global genai -docstring 'Transform whole-file' F ':genai-prompt diff<ret>'
map global genai -docstring 'Transform multi-file' f ':genai-prompt multidiff<ret>'
map global genai -docstring 'New conversation' n ':edit -scratch<ret>:genai-start-conv<ret>i'
map global genai -docstring 'Start conversation' s ':genai-start-conv<ret>'
map global genai -docstring 'Delete conversation' d ':genai remove-conv<ret>'
map global genai -docstring 'Open prompts' p ':genai-open-prompts<ret>'


# Set single file mode as default
genai-set-context false

# Add key bindings
map global user -docstring 'Open GenAI menu' g ':enter-user-mode genai<ret>'
map global normal -docstring 'Open GenAI menu' <c-a> ':enter-user-mode genai<ret>'
map global insert -docstring 'Open GenAI menu' <c-a> '<esc>:enter-user-mode genai<ret>'


# Word Diff Highlighter
# ─────────────────────
hook -once global WinSetOption filetype=diff %{
  require-module diff
  add-highlighter shared/diff/ regex "\{\+[^\n]+?\+\}" 0:green,default
  add-highlighter shared/diff/ regex "\[-[^\n]+?-\]" 0:red,default
}


# Git Diff Buffer
# ─────────────────────
define-command -docstring 'Open current git diff' -params 1 git-diff %{
  edit -scratch '*git-diff*'
  set-option buffer filetype 'git-diff'
  evaluate-commands -draft -no-hooks %{
    try %{
      execute-keys -draft "%%s^[^\n].+$<ret>"
      # Select all, replace selection with git diff (without stdin).
      execute-keys -draft "%%|:|git diff '%arg{1}'<ret>"
    } catch %{
      # Select all, replace selection with git diff (without stdin).
      execute-keys -draft "%%d<a-!>git diff '%arg{1}'<ret>ggd"
    }
  }
}
map global user -docstring 'Open current git diff' d ':git-diff HEAD<ret>'
map global user -docstring 'Open parent git diff' D ':git-diff HEAD^<ret>'

# Use Alt-Enter or Enter to jump to the original or modified file.
hook global WinSetOption filetype=diff %{
  require-module diff
  map buffer normal <a-ret> ':diff-jump -<ret>'
}
