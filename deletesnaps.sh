#!/bin/bash
# set -x
set -eo pipefail

# Configuration
LOG_DIR="$HOME/Documents/screenshots"
LOG_DAYS=-1
PURGE_FILE="$LOG_DIR/LOG_PURGE"

# Redirect all output to LOG_PURGE file
exec >"$PURGE_FILE"

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Check if LOG_DIR exists
if [ ! -d "$LOG_DIR" ]; then
    log_message "Error: Screenshot directory $LOG_DIR does not exist. Exiting."
    exit 1
fi

# Start logging
log_message "Starting screenshot purge process"

# Delete old screenshots
delete_screenshots(){
    log_message "Looking for screenshots older than $LOG_DAYS days"
    find "$LOG_DIR" -mtime +$LOG_DAYS \( \
        -iname '*.png' -o \
        -iname '*.jpeg' -o \
        -iname '*.jpg' \
        \) -type f -delete -print | while read -r file; do
        log_message "Deleted: $file"
    done
}

# Log summary
delete_screenshots
DELETED_COUNT=$(grep -c "Deleted:" "$PURGE_FILE" || true)
if [ "$DELETED_COUNT" -eq 0 ]; then 
    log_message "There are no screenshots older than $LOG_DAYS"
else
    echo ""
    echo "--------------------------------------------------------"
    log_message "Summary: Deleted $DELETED_COUNT screenshots"
    log_message "Screenshot purge process completed"
    echo "--------------------------------------------------------"
fi
