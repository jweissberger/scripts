#!/bin/bash

set -eo pipefail

LOG_DIR=$HOME/documents/screenshots
SEARCH_DIRS=("$HOME/Downloads")

for file in "${SEARCH_DIRS[@]}"; do
    find "$file" \( -name '*.jpeg' -or -name '*.png' \) -exec mv "{}" "$LOG_DIR" \;
done
