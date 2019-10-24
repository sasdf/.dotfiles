# .-----------------.
# | Sync tmp2 local |
# '-----------------'

# Initialize local dir
if [ ! -z "$DOTS_PATH_LOCAL" ]; then
    mkdir -p "$DOTS_PATH_LOCAL"
    chmod 700 "$DOTS_PATH_LOCAL"
fi
if [ ! -z "$DOTS_PATH_LOCAL_TMP" ]; then
    mkdir -p "$DOTS_PATH_LOCAL_TMP"
    chmod 700 "$DOTS_PATH_LOCAL_TMP"
fi


# Skip if there's no local directory
if [ -z "$DOTS_PATH_LOCAL" ] || [ -z "$DOTS_PATH_LOCAL_TMP" ]; then
    return 0
fi


# Skip if there's no server to sync
if [ -z "$DOTS_LOCAL_SYNC_SERVER" ]; then
    return 0
fi


echo "Syncing local directory..."


# Skip if we're syncing to ourself
if [ "$(hostname -s)" == "$DOTS_LOCAL_SYNC_SERVER" ] ; then
    echo "    Skip on upstream server"
    return 0
fi


echo "Checking local directory timestamp..."


# Check local existance
if [ -d "$DOTS_PATH_LOCAL" ] ; then
    REMOTETS="$(ssh $DOTS_LOCAL_SYNC_SERVER "cat $DOTS_PATH_LOCAL/timestamp 2>/dev/null")"
    LOCALTS="$(cat "$DOTS_PATH_LOCAL/timestamp" 2>/dev/null)"
    CURRENTTS="$(date +%s)"
    if [ -z "$REMOTETS" ]; then
        echo "    Unable to find local directory on server $DOTS_LOCAL_SYNC_SERVER"
        return 0
    fi
    if ((LOCALTS > 0)) && ((REMOTETS <= LOCALTS)) && ((CURRENTTS - 86400 < LOCALTS)); then
        echo "    Timestamp matched, skipped"
        return 0
    fi
else
    echo "    Local directory is not exist"
fi


# Confirm
printf '%s' "Sync local directory? [yes/No] "
read ans
if [ "$ans" != "yes" ]; then
    echo "    Skipped"
    return 0
fi


# Start syncing
rsync -a -A -X --delete --info=progress2 -e ssh "$DOTS_LOCAL_SYNC_SERVER:$DOTS_PATH_LOCAL/" "$DOTS_PATH_LOCAL/"
echo "$CURRENTTS" > "$DOTS_PATH_LOCAL/timestamp"
