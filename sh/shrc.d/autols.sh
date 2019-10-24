# .---------.
# | Auto ls |
# '---------'

function cl () {
    \cd "$@" && ls
}
alias cd='\cl'
