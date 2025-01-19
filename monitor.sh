#!/usr/bin/env bash
if [[ $(id -u) -ne 0 ]]; then
    echo "Run $0 as root or with sudo"
    exit 1
fi
#tx rx
shopt -s globstar dotglob
tx_sum=0
rx_sum=0
for file in /sys/class/net/*; do
    if [[ -d "$file/device" ]]; then
        tx=$(cat "$file/statistics/tx_bytes")
        rx=$(cat "$file/statistics/rx_bytes")
        tx_sum=$((tx_sum + tx))
        rx_sum=$((rx_sum + rx))
    fi 
done
#cpu usage
read -r -a cpu_usage_a <<<"$(vmstat | sed -n 3p)"
cpu_usage="${cpu_usage_a[-3]}"
cpu_usage=$((100 - cpu_usage))
#ram usage
read -r -a ram_usage_a <<<"$(free -b | sed -n 2p)"
total="${ram_usage_a[1]}"
free="${ram_usage_a[2]}"
ram_usage=$(python3 -c "print(f'{$free / $total * 100 :.2f}')")
#handle cron or interactive
res="• [$(date)] $cpu_usage $ram_usage $tx_sum $rx_sum"
if [[ -t 0 ]]; then
    echo -e "• [date]\t\t\t cpu% mem% tx rx"
    echo $res
    #compare against last monitor
    file_name='/var/log/monitor.log'
    if [[ -s "$file_name" ]]; then
        last_res=$(tail -1 "$file_name")
        read -r -a res_a <<<"$res"
        read -r -a last_a <<<"$last_res"
        current_cpu="${res_a[-4]}"
        last_cpu="${last_a[-4]}"
        cpu_change=""
        if [[ "$current_cpu" == "$last_cpu" ]]; then
            cpu_change="same cpu usage"
        elif [[ "$current_cpu" > "$last_cpu" ]]; then
            cpu_change="more cpu usage"
        else
            cpu_change="less cpu usage"
        fi
        current_ram="${res_a[-3]}"
        last_ram="${last_a[-3]}"
        ram_change=""
        if [[ "$current_ram" == "$last_ram" ]]; then
            ram_change="same ram usage"
        elif [[ "$current_ram" > "$last_ram" ]]; then
            ram_change="more ram usage"
        else
            ram_change="less ram usage"
        fi
        echo "$cpu_change. current: $current_cpu% last: $last_cpu%"
        echo "$ram_change. current: $current_ram% last: $last_ram%" 
    fi
else
    echo $res >> /var/log/monitor.log
fi
