#!/usr/bin/env bash
if [[ $(id -u) -ne 0 ]]; then
    echo "Run $0 as root or with sudo"
    exit 1
fi
num_of_processes() {
    echo "$(ps auxh | wc -l)"
}

echo 'Welcome'
PS3='~Select an option: '
options=('Show current stats' 'Show last 5 backup logs' 'Perform backup' 'Perform cleanup' 'Show the number of running processes' 'Quit')
select option in "${options[@]}"; do
    case $option in
    "${options[0]}")
        /usr/local/bin/monitor.sh
        ;;
    "${options[1]}")
        /usr/local/bin/backup.sh l
        ;;
    "${options[2]}")
        /usr/local/bin/backup.sh
        ;;
    "${options[3]}")
        /usr/local/bin/cleanup.sh
        ;;
    "${options[4]}")
        num_of_processes
        ;;
    "${options[5]}")
        exit 0
        ;;
        esac
done
