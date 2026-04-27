#!/bin/bash

echo "Creating Backup"

mkdir -p backups

DATE=$(date +%Y-%m-%d-%H-%M)
BACKUP_DIR="backups/backup-$DATE"

mkdir -p "$BACKUP_DIR"

cp docker-compose.yml "$BACKUP_DIR/"
cp -r traefik "$BACKUP_DIR/" 2>/dev/null
cp -r monitoring "$BACKUP_DIR/" 2>/dev/null

echo "Backup save in $BACKUP_DIR"
