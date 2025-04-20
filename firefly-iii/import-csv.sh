#!/bin/bash
WATCH_DIR="./import"

inotifywait -m -e close_write --format '%f' "$WATCH_DIR" | while read filename; do
  if [[ "$filename" == *.csv ]]; then
    base="${filename%.csv}"
    echo "Detected new file: $filename, triggering import..."

    docker exec firefly_iii_importer php artisan importer:import "/import/import-config.json" "/import/${filename}"

    echo "Import complete for $filename"
  fi
done
