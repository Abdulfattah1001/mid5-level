#! /bin/bash

LOG_FILE="/var/log/devopsfetch.log"
MAX_LOG_SIZE=10485760 #10MB

log_activity(){
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