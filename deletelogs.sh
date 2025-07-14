#!/bin/bash
# set -x
set -eo pipefail

# Configuration
LOG_DIR="$HOME/Documents/atlas_logFiles"
LOG_DAYS=10
PURGE_FILE="$LOG_DIR/LOG_PURGE"

# Redirect all output to LOG_PURGE file
exec >"$PURGE_FILE"

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
delete_logs() {
    log_message "Looking for log files older than $LOG_DAYS days"
    find "$LOG_DIR" -mtime +$LOG_DAYS \( \
        -name 'mongodb.*' -o \
        -name '*.json' -o \
        -name '*.csv' -o \
        -name '*.log' -o \
        -name '*.gz' -o \
        -name '*.tar' -o \
        -name '*_proxy' -o \
        -name 'mtm-*' -o \
        -name '*.zip' -o \
        -name 'metrics*' -o \
        -name '.DS_Store' \
        \) -type f -delete -print | while read -r file; do
        log_message "Deleted: $file"
    done

   # Clean up directories
    echo ""
    log_message "Looking for directories older than $LOG_DAYS days"
    find "$LOG_DIR" -mtime +$LOG_DAYS -depth 1 -type d -delete -print | while read -r dir; do
        log_message "Removed directory: $dir"
    done
}

# Log summary

separator="--------------------------------------------------------"

print_separator() {
echo "$separator"
}

delete_logs
DEL_COUNT=$(grep -c "Deleted:" "$PURGE_FILE" || true)
EMPTY_DIR=$(grep -c "Removed directory:" "$PURGE_FILE" || true)

if [[ "$EMPTY_DIR" -eq 0 ]]; then
    echo ""
    print_separator
    log_message "There are no directories older than $LOG_DAYS days"
else
    echo ""
    print_separator
    log_message "Summary: Removed $EMPTY_DIR directories"
    print_separator
fi

if [ "$DEL_COUNT" -eq 0 ]; then
    log_message "There are no files older than $LOG_DAYS days"
    print_separator
else
    echo ""
    print_separator
    log_message "Summary: Deleted $DEL_COUNT log files."
    log_message "Log purge process completed"
    print_separator
fi
# set +x
