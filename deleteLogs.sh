#!/bin/bash

# Configuration
LOG_DIR="$HOME/Documents/atlas_logFiles"
LOG_DAYS=10
PURGE_FILE="$LOG_DIR/LOG_PURGE"

# Redirect all output to LOG_PURGE file
exec > "$PURGE_FILE"

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Check if LOG_DIR exists
if [ ! -d "$LOG_DIR" ]; then
    log_message "Error: Log directory $LOG_DIR does not exist. Exiting."
    exit 1
fi

# Start logging
log_message "Starting log purge process"

# Delete old log files
log_message "Deleting log files older than $LOG_DAYS days"
find "$LOG_DIR" -mtime +$LOG_DAYS \( \
    -name 'mongodb.*' -o \
    -name '*.json' -o \
    -name '*.csv' -o \
    -name '*.log' -o \
    -name '*.gz' -o \
    -name '*.tar' -o \
    -name '*_proxy' -o \
    -name 'mtm-*' -o \
    -name 'metrics*' -o \
    -name '.DS_Store' \
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
log_message "Summary: Deleted $DELETED_COUNT log files and removed $EMPTY_DIR_COUNT empty directories"

log_message "Log purge process completed"