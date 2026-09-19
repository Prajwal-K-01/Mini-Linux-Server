#!/bin/bash

# ==========================================================
# Mini Linux Server - Automated Backup Script
# Author: Prajwal K
# Description: Creates compressed backups of server data
# ==========================================================

# -------------------- CONFIGURATION -----------------------

SOURCE_DIR="/server-data/application"
BACKUP_DIR="/server-data/backups"
LOG_FILE="/server-data/logs/backup.log"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/application_backup_$DATE.tar.gz"

# Number of backups to keep
BACKUPS_TO_KEEP=5

# -------------------- COLORS ------------------------------

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# -------------------- FUNCTIONS ---------------------------

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# -------------------- START -------------------------------

echo
echo "=================================================="
echo "          MINI LINUX SERVER BACKUP"
echo "=================================================="
echo

# Check source directory
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}ERROR: Source directory does not exist.${NC}"
    log_message "ERROR: Source directory not found: $SOURCE_DIR"
    exit 1
fi

# Create required directories
mkdir -p "$BACKUP_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

log_message "Backup process started."
log_message "Source: $SOURCE_DIR"
log_message "Destination: $BACKUP_FILE"

# -------------------- CREATE BACKUP -----------------------

echo -e "${YELLOW}Creating backup...${NC}"

tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Backup created successfully.${NC}"
    log_message "Backup created successfully."

else
    echo -e "${RED}Backup failed.${NC}"
    log_message "ERROR: Backup creation failed."
    exit 1
fi

# -------------------- VERIFY BACKUP -----------------------

echo -e "${YELLOW}Verifying backup...${NC}"

if tar -tzf "$BACKUP_FILE" > /dev/null 2>&1; then
    echo -e "${GREEN}Backup verification successful.${NC}"
    log_message "Backup verification successful."

else
    echo -e "${RED}Backup verification failed.${NC}"
    log_message "ERROR: Backup verification failed."
    exit 1
fi

# -------------------- BACKUP SIZE -------------------------

BACKUP_SIZE=$(du -h "$BACKUP_FILE" | awk '{print $1}')

echo
echo "Backup File : $BACKUP_FILE"
echo "Backup Size : $BACKUP_SIZE"

log_message "Backup size: $BACKUP_SIZE"

# -------------------- CLEAN OLD BACKUPS ------------------

echo
echo -e "${YELLOW}Checking old backups...${NC}"

BACKUP_COUNT=$(find "$BACKUP_DIR" -type f -name "application_backup_*.tar.gz" | wc -l)

if [ "$BACKUP_COUNT" -gt "$BACKUPS_TO_KEEP" ]; then

    find "$BACKUP_DIR" \
        -type f \
        -name "application_backup_*.tar.gz" \
        -printf '%T@ %p\n' |
        sort -n |
        head -n "$((BACKUP_COUNT - BACKUPS_TO_KEEP))" |
        cut -d' ' -f2- |
        xargs -r rm -f

    log_message "Old backups removed."
fi

# -------------------- FINAL STATUS -----------------------

echo
echo "=================================================="
echo -e "${GREEN}BACKUP STATUS: SUCCESS${NC}"
echo "=================================================="
echo

log_message "Backup process completed successfully."

exit 0
