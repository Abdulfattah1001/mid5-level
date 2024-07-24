#! /bin/bash

MAX_LOG_SIZE=10485760 #10MB
LOG_DIR="/var/log/devopsfetch"
LOG_FILE="$LOG_DIR/devopsfetch.log"

if [ ! -d "$LOG_DIR" ];then
    mkdir -p "$LOG_DIR"
    echo "created log directory: $LOG_DIR"
fi


check_sudo(){
    if ! sudo -n true 2>/dev/null;
        then
            echo "Error: This Script requires sudo privileges."
            exit 1
    fi
}

log_activity(){
    check_sudo
    while true; do
        date >> "$LOG_FILE"
        sudo lsof -i -P -n | grep LISTEN >> "$LOG_FLE"
        sudo docker ps -a >> "$LOG_FILE"
        sudo nginx -T 2>/dev/null | grep -E 'server_name|listen' >> "$LOG_FILE"
        who >> "$LOG_FILE"

        if [ $(stat -c%s "$LOG_FLE") -ge $MAX_LOG_SIZE ]; then
            mv "$LOG_FILE" "$LOG_FILE.$(date +%%m%d%H%M%S)"
            touch "$LOG_FILE"
        fi

        sleep 60
    done
}

log_activity