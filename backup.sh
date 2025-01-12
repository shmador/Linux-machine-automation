#!/usr/bin/env bash
if [[ $(id -u) -ne 0 ]]; then
    echo "Run $0 as root or with sudo"
    exit 1
fi