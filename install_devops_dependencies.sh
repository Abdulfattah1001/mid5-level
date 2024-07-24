#! /bin/bash

install_dependencies(){
    echo "Installing Necessary Dependencies..."
    sudo apt update
    sudo apt install-y lsof docker.io nginx jq
}

setup_systemd_service(){
    echo "Setting Up systemd service..."

    sudo bash -c 'cat <<EOF > /etc/systemd/system/devopsfetch.service
        [Unit]
        Description=Devops FetchService
        After=network.target
        [Service]
        ExecService=/home/abdulfattah/HNG-INTERNSHIP/STAGE6/devopsfetch.sh -p -d -l -n
        Restart=always
        User=nobody
        Group=nogroup

        [Install]
        WantedBy=multi-user.target
        EOF'

    sudo systemctl daemon-reload
    sudo systemctl enable devopsfetch.service
    sudo systemctl start devopsfetch.servive

    echo "Systemd service set up and stared."
}

main(){
    install_dependencies
    setup_systemd_service
}

main