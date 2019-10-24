# .------------.
# | Check mail |
# '------------'

if [ -x /bin/mail ] ; then 
    /bin/mail -E 2>/dev/null
    case $? in
        0)
        echo "You have new mail."
        ;;
        2)
        echo "You have mail."
        ;;
    esac
fi
