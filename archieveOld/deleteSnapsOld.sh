#!/bin/bash
LOG_DIR=$HOME/Documents/screenshots
LOG_DAYS=5

# Delete old screenshots and empty directories, then create a timestamp file "LOG_PURGE" as a reminder.

# Delete screenshots older than LOG_DAYS that match the specified patterns
find "$LOG_DIR" -mtime +$LOG_DAYS \( -name '*.png' -or -name '*.jpeg' \) -type f -delete

# Clean up empty directories
find "$LOG_DIR" -type d -empty -delete

# Create or update the LOG_PURGE file with the current timestamp
date >"$LOG_DIR/LOG_PURGE"
