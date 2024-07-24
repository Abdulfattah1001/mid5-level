#! /bin/bash

check_sudo(){
    if ! sudo -n true 2>/dev/null;
        then
            echo "Error: This Script requires sudo privileges."
            exit 1
    fi
}

list_ports(){
    echo "Active Ports and Services: "
    sudo lsof -i -P -n | grep LISTEN
}

port_details(){
    port_number=$1
    echo "Details for port $port_number:"
    sudo lsof -i -P -n | grep LISTEN | grep ":$port_number"
}

list_docker(){
    echo "Docker Images:"
    sudo docker images
    echo "Docker Containers:"
    sudo docker ps -a
}

docker_details(){
    container_name=$1
    echo "Details for Continaer $container_name:"
    sudo docker inspect "$container_name"
}

list_nginx_domains(){
    echo "Nginx Domains and Ports:"
    sudo nginx -T 2>/dev/null | grep -E 'server_name|listen'
}

list_logins(){
    echo "user Logins:"
    who
}

user_details(){
    username=$1
    # echo "Details for user $username"
    # last "$username"
    echo "Details for user $username:"
    echo "User ID : $(id -u "$username")"
    echo "Group ID : $(id -g "$username")"
    echo "Groups : $(id -Gn "$username")"
    echo "Home Directory: $(eval echo ~$username)"
    echo "Login Shell: $(getent passwd "$username" | cut -d: -f7)"
    #echo "Login Shell: $(getent passwd "$username" | tail -1 | awk '{print $4, $5, $6, $7}')"
}

time_range(){
    range=$1
    echo "Activities within tiime range $range:"
    sudo journalctl --since="$range"
}

nginx_details(){
    domain=$1
    echo "Details for nginx domain $domain:"
    sudo nginx -T 2>/dev/null | grep -A 10 -E "server_name.*$domain"
}

nginx_config(){
    nginx_conf="/etc/nginx/nginx.conf"
    echo "Nginx Configuration:"
    cat "$nginx_conf"
}

show_help(){
    echo "Usage: $0 [-p PORT] [-d] [-l] [-n]"
    echo "Options:"
    echo " -p, --port PORT Display active ports or detailed information about a specific port"
    echo " -d, --docker List all docker images and containers"
    echo " -l, --logins List user logins"
    echo " -n, --nginx Displa Nginx configuration"
    echo " -u, --users [USERNAME] List all users and their last login times, or provide detailed information about a specific user"
    echo " -t, --time [RANGE] Display activities withing a specified time range"
}

main(){
    check_sudo
    while [[ "$1" != "" ]]; do
        case $1 in
            -p | --port)
            shift
            if [[ "$1" =~ ^[0-9]+$ ]]; then
                port_details "$1"
                shift
            else
                list_ports
            fi
            ;;
            -d | --docker)
            shift
            if [[ "$1" != ""  && ! "$1" =~ ^- ]]; then
                docker_details "$1"
                shift
            else
                list_docker
            fi
            ;;
            -l | --logins)
            shift
            if [[ "$1" != "" && ! "$1" =~ ^- ]]; then
                list_logins "$1"
                shift
            else
                list_logins
            fi
            ;;
            -n | --nginx)
            shift
            if [[ "$1" != "" && ! "$1" =~ ^- ]]; then
                nginx_details "$1"
                shift
            else
                list_nginx_domains
            fi
            ;;
            -u | --users)
            shift
            if [[ "$1" != "" && ! "$1" =~ ^- ]]; then
                user_details "$1"
                shift
            else
                list_logins
            fi
            ;;
            -t | --time)
            shift
            if [[ "$1" != "" && ! "$1" =~ ^- ]]; then
                time_range "$1"
                shift
            else
                show_help
            fi
            ;;
            -h | --help)
            show_help
            ;;
            *)
            show_help
            exit 1
            ;;
        esac
    done
}

main "$@"