#!/usr/bin/env bash
if [[ $(id -u) -ne 0 ]]; then
    echo "Run $0 as root or with sudo"
    exit 1
fi
remove_file() {
    for file in "$to_remove"/*; do
        last_modification_seconds=$(stat --format=%Y "$file")
        last_modfication_in_days=$((($(date +%s) - last_modification_seconds) / 86400))
        if [[ "$last_modfication_in_days" -gt 16 ]]; then
            #ask for confirmation if size is over 10 MiB
            if [[ -t 0 ]]; then
                read -r -a size_in_bytes_a <<<"$(wc -c "$file")"
                size_in_bytes="${size_in_bytes_a[0]}"
                size_limit=$(( 10 * 1024 * 1024 ))
                if [[ "$size_in_bytes" -gt "$size_limit" ]]; then
                    read -p "$file is bigger then 10 MiB. Delete anyways?(y/n) " confirm
                    if [[ ${confirm^^} != "Y" ]]; then
                        continue
                    fi
                fi
            fi
            rm -f "$file"
        fi
    done
}
#directories to scan
dir_a=( "/tmp" "/var/tmp" "/var/log" )
for dir in ${dir_a[@]}; do
    to_remove="$dir"
    remove_file()
done


