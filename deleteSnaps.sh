#!/bin/bash

set -eo pipefail

# Configuration
LOG_DIR="$HOME/Documents/screenshots"
LOG_DAYS=5
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
log_message "Deleting screenshots older than $LOG_DAYS days"
find "$LOG_DIR" -mtime +$LOG_DAYS \( \
    -name '*.png' -o \
    -name '*.jpeg' -o \
    -name '*.jpg' \
    \) -type f -delete -print | while read -r file; do
    log_message "Deleted: $file"
done

# Clean up empty directories
log_message "Removing empty directories"
find "$LOG_DIR" -type d -empty -delete -print | while read -r dir; do
    log_message "Removed empty directory: $dir"
done

# Log summary
DELETED_COUNT=$(grep -c "Deleted:" "$PURGE_FILE")
EMPTY_DIR_COUNT=$(grep -c "Removed empty directory:" "$PURGE_FILE")
log_message "Summary: Deleted $DELETED_COUNT screenshots and removed $EMPTY_DIR_COUNT empty directories"

log_message "Screenshot purge process completed"
