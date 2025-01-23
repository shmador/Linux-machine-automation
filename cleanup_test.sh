#!/usr/bin/env bash

[[ $(id -u) -ne 0 ]] && {
    echo "Run as root"
    exit 2
}

read -rp "Create data more than 10MiB? [Y/n] " response
response=${response:-y}
count=10
[[ "$response" =~ Y|y ]] && count=300
aged='aged'
tmp_dirs=('/tmp' '/var/tmp' '/var/log')

for i in {1..5}; do
    for dir in "${tmp_dirs[@]}"; do
        dirname="$dir/$aged-$i"
        mkdir "$dirname" 2>/dev/null
        for j in {1..7}; do
            filename="$dirname/$aged-file$j"
            dd if=/dev/urandom of="$filename" count=$count bs=1KiB status=none
            touch -d "19 days ago" "$filename"
        done
    done
done