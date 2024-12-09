#!/bin/bash
LOG_DIR=$HOME/Documents/atlas_logFiles
LOG_DAYS=10

# Delete old files and empty directories, then create a timestamp file "LOG_PURGE" as a reminder.

# Delete files older than LOG_DAYS that match the specified patterns
find "$LOG_DIR" -mtime +$LOG_DAYS \( -name '*.json' -or -name '*.csv' -or -name '*.log' -or -name '*.gz' -or -name '*.tar' -or -name '*_proxy' -or -name 'mtm-*' \) -type f -delete

# Clean up empty directories
find "$LOG_DIR" -type d -empty -delete

# Create or update the LOG_PURGE file with the current timestamp
date >"$LOG_DIR/LOG_PURGE"
