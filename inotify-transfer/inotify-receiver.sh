#!/bin/bash

WATCH_DIR="."

inotifywait -m -e close_write --format "%f" "$WATCH_DIR" | while read filename; do
	if [[ "$filename" == *.epub ]]; then
		calibredb add "$filename" --with-library /opt/calibre-web
	fi
done
