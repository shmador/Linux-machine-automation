if [[ $(id -u) -eq 0 ]]; then
    echo "Run $0 as root or with sudo"
    exit 1
fi

cp -f "monitor.sh" "/usr/local/bin/monitor.sh"
cp -f "cleanup.sh" "/usr/local/bin/cleanup.sh"
cp -f "backup.sh" "/usr/local/bin/backup.sh"
cp -f "menu.sh" "/usr/local/bin/menu.sh"
chmod +x "/usr/local/bin/monitor.sh"
chmod +x "/usr/local/bin/cleanup.sh"
chmod +x "/usr/local/bin/backup.sh"
chmod +x "/usr/local/bin/menu.sh"

(
    crontab -l 2>/dev/null
    echo "0 * * * * /usr/local/bin/monitor.sh"
    echo "0 0 4,20 * * /usr/local/bin/backup.sh"
    echo "0 0 1 * * /usr/local/bin/cleanup.sh"
) | crontab -
