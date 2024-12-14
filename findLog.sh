#!/bin/bash

set -eo pipefail

LOG_DIR=$HOME/documents/atlas_logFiles
SEARCH_DIRS=("$HOME/Downloads")

for file in "${SEARCH_DIRS[@]}"; do
    find "$file" \( -name '*.mongodb.*' -or -name 'mongodb-*' -or -name '*.log' -or -name '*.zip' \) -exec mv "{}" "$LOG_DIR" \;
done
