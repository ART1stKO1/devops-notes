#!/usr/bin/env bash
backup_date=$(date +%F) started_at=$(date -u '+%F %T UTC')
backup_dir="${BACKUP_DIR:-$HOME/study-backups}"
archive="$backup_dir/backup-demo-${backup_date}.tar.gz"

mkdir -p "$backup_dir" || exit 1

temp_archive=$(mktemp "$backup_dir/.backup-demo.XXXXXX") || exit 1
trap 'rm -f -- "$temp_archive"' EXIT

if tar -czf "$temp_archive" -C "$HOME/study/week4/tue" backup-demo; then
	if ! tar -tzf "$temp_archive" > /dev/null; then
		printf 'Archive verification failed: %s\n' "$archive" >&2
		exit 1
	fi
	mv -T -- "$temp_archive" "$archive" || exit 1
	printf '[%s] Backup created: %s\n' "$started_at" "$archive"
	find "$backup_dir" -maxdepth 1 -type f -name 'backup-demo-*.tar.gz' -mtime +6 -delete
else
	printf 'Backup failed\n' >&2
	exit 1
fi
