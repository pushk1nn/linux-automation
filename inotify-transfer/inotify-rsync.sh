#!/bin/bash

WATCH_DIR=""

inotifywait -m -e close_write --format '%f' "$WATCH_DIR" ; while read filename; do
	if [[ "$filename" == *.csv ]]; then
		echo "Detected new file: $filename"

	fi
done
