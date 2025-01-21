#!/usr/bin/env bash
if [[ $(id -u) -ne 0 ]]; then
    echo "Run $0 as root or with sudo"
    exit 1
fi
#perform backup
TARGET='/home'
read -r -a dir_size_in_bytes_a <<<"$(du -sb "$TARGET")"
dir_size="${dir_size_in_bytes_a[0]}"
free_space=$(df --output=avail / | tail -1)
format="+%Y_%m_%d_%H_%M_%S"
current_date_time="$(date "$format")"
message=""
backup_dir="/opt/sysmonitor/backups/"
log_path="/var/log/backup.log"
if [[ "$dir_size" -lt "$free_space" ]]; then
    DESTINATION="${backup_dir}${current_date_time}_home_backup.tar.gz"
    tar czf "$DESTINATION" --ignore-failed-read "$TARGET" 2>/dev/null 2>&1
    message="successful backup $current_date_time"
else
    message="not enough disk space to create backup $current_date_time"
fi
echo "$message" >> "$log_path"
#remove old backups
for file in "$backup_dir"/*; do
    last_modification_seconds=$(stat --format=%Y "$file")
    last_modfication_in_days=$((($(date +%s) - last_modification_seconds) / 86400))
    if [[ "$last_modfication_in_days" -gt 7 ]]; then
        rm -f "$file"
    fi
done
#display last 5 logs
if [[ -t 0 && $1 == 'l' ]]; then
    if [[ ! -s "$file_name" ]]; then
        echo "no current logs found"
    else
        lines=$(tail -5 "$file_name")
        echo "$lines"
    fi
fi
