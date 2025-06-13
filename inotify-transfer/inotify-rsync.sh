#!/bin/bash

WATCH_DIR="."
USER=""
REMOTE_HOST=""
REMOTE_DIR=""
FILETYPE=""

inotifywait -r -m -e close_write --format '%f' "$WATCH_DIR" | while read filename; do
        if [[ "$filename" == *."$FILETYPE" ]]; then
                rsync -avz *."$FILETYPE" "$USER"@"$REMOTE_HOST":"$REMOTE_DIR"
        fi
done
