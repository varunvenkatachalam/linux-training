#!/bin/bash

# Backup Manager

# Read input arguments
SRC_DIR="$1"
DEST_DIR="$2"
FILE_EXT="$3"

# Check argument count
if [ $# -ne 3 ]; then
    echo "Usage: $0 <source_directory> <backup_directory> <file_extension>"
    exit 1
fi

# Check source directory
if [ ! -d "$SRC_DIR" ]; then
    echo "Source directory not found."
    exit 1
fi

# Create backup directory if missing
if [ ! -d "$DEST_DIR" ]; then
    mkdir -p "$DEST_DIR"
    if [ $? -ne 0 ]; then
        echo "Unable to create backup directory."
        exit 1
    fi
fi

# Export backup counter
export BACKUP_COUNT=0
TOTAL_BACKUP_SIZE=0

# Collect files using globbing
BACKUP_FILES=( "$SRC_DIR"/*"$FILE_EXT" )

# Check if files exist
if [ ! -e "${BACKUP_FILES[0]}" ]; then
    echo "No files with extension $FILE_EXT found."
    exit 0
fi

echo "Files to be backed up:"
echo "----------------------"

# Display file details
for f in "${BACKUP_FILES[@]}"; do
    echo "$(basename "$f") - $(stat -c %s "$f") bytes"
done

echo "----------------------"

# Start backup process
for f in "${BACKUP_FILES[@]}"; do
    fname=$(basename "$f")
    dest_file="$DEST_DIR/$fname"

    if [ -f "$dest_file" ]; then
        if [ "$f" -nt "$dest_file" ]; then
            cp "$f" "$dest_file"
        else
            continue
        fi
    else
        cp "$f" "$dest_file"
    fi

    size=$(stat -c %s "$f")
    TOTAL_BACKUP_SIZE=$((TOTAL_BACKUP_SIZE + size))
    BACKUP_COUNT=$((BACKUP_COUNT + 1))
done

# Create backup report
REPORT="$DEST_DIR/backup_report.log"

echo "Backup Summary Report" > "$REPORT"
echo "---------------------" >> "$REPORT"
echo "Files backed up : $BACKUP_COUNT" >> "$REPORT"
echo "Total size      : $TOTAL_BACKUP_SIZE bytes" >> "$REPORT"
echo "Backup location : $DEST_DIR" >> "$REPORT"
echo "Date & Time     : $(date)" >> "$REPORT"

echo "Backup completed."
echo "Report generated at $REPORT"
