# .--------------.
# | TTY Settings |
# '--------------'

# check xon/xoff settings
# stty -a | egrep -o -- '-?\<(ix\w*|start|stop)'

if [ -t 0 ]; then # term test?
    # Turn off TTY "start" and "stop" commands in all interactive shells.
    # They default to C-q and C-s, Bash uses C-s to do a forward history search.
    stty start ''
    stty stop  ''
    stty -ixon # disable XON/XOFF flow control
    stty ixoff # enable sending (to app) of start/stop characters
    stty ixany # let any character restart output, not only start character
fi
