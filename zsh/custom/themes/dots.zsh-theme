function showuser {
    if [ "$1" != "n" ]; then
        export SHOWUSER=1
    else
        unset SHOWUSER
    fi
}

function _hostname_prompt {
    if [ -z "$TMUX" ]; then
        echo "%{$fg_bold[blue]%}%n@%m "
    elif [ ! -z "$SHOWUSER" ]; then
        echo "%{$fg_bold[blue]%}%n "
    fi
}

function _git_current_branch_prompt {
    [[ "${PWD}" =~ '^/google/(.*)' ]] && return
    local branch=$(git_current_branch)
    if [ ! -z "$branch" ]; then
        echo "%{$fg[yellow]%} (${branch})"
    fi
}

function _conda_env_prompt {
    if [ ! -z "$CONDA_DEFAULT_ENV" ] && [ "$CONDA_DEFAULT_ENV" != "base" ]; then
        echo "%{$fg[magenta]%} ($CONDA_DEFAULT_ENV)"
    fi
}

PROMPT='
'\
' '\
'$(_hostname_prompt)'\
'%(?,'\
'%{$fg_bold[green]%}'\
','\
'%{$fg_bold[red]%}'\
')'\
'%(!.#.>) '\
'%{$FG[247]%}'\
'%~'\
'$(_conda_env_prompt)'\
'$(_git_current_branch_prompt)'\
'
'\
'%{$FG[109]%}'\
'.. '\
'%{$reset_color%}'\
''

PROMPT2=''\
'%{$fg_bold[yellow]%}'\
'.. '\
'%{$reset_color%}'\
''
