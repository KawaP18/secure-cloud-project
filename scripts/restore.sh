if [ -z "$1"]; then
	echo "Usage: ./scripts/restore.sh backups/backup-folder"
	exit 1
fi

echo "Restroing Files"

cp "$1/docker-compose.yml" .
cp -r "$1/traefik" . 2>/dev/null
cp -r "$1/monitoring" . 2>/dev/null

echo "Restarting containers"
docker compose down
docker compose up -d

echo "Restore Complete"
