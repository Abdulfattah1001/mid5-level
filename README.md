# DevOpsFetch Tool Documentation

## OverviewDevOpsFetch is a tool for retrieving and monitoring server information, including active ports, user logins, Nginx configurations, Docker images, and container statuses. It consists of three main scripts: `devopsfetch.sh`, `install_devopsfetch.sh`, and `devopsfetch_monitor.sh`.

### Table of Contents <br />1. Installation <br />2. Usage <br /> 3. Command Line Flags  4. Continuous Monitoring <br />5. Log Rotation <br />6. Help and Documentation

## 1. Installation

### Prerequisites- Ubuntu or a similar Linux distribution- `sudo` privileges

### Steps 1. <br />**Clone the Repository:**    ```sh    git clone <repository_url>    cd <repository_directory>```
### Steps 2. **Run the Installation Script:**    ```sh    sudo ./install_devopsfetch.sh    ```   This script will install the necessary dependencies, create a `systemd` service, and start the service for continuous monitoring.

### install_devopsfetch.sh This script performs the following actions:-<br /> Installs required packages (`lsof`, `docker.io`, `nginx`, `jq`).-<br />Sets up a `systemd` service to run `devopsfetch_monitor.sh`.- <br />Enables and starts the `devopsfetch_monitor` service.

## 2. Usage

### devopsfetch.shThis is the main script for retrieving specific system information. It supports various command-line flags to display information about ports, Docker containers, Nginx configurations, user logins, and activities within a specified time range.

### Example Commands- 
**Display all active ports and services:**  ```sh  ./devopsfetch.sh -p  ```-<br /> **Provide detailed information about a specific port:**  ```sh  ./devopsfetch.sh -p <port_number>  ```-<br /> **List all Docker images and containers:**  ```sh  ./devopsfetch.sh -d  ```-<br /> **Provide detailed information about a specific container:**  ```sh  ./devopsfetch.sh -d <container_name>  ```-<br /> **Display all Nginx domains and their ports:**  ```sh  ./devopsfetch.sh -n  ```-<br /> **Provide detailed configuration information for a specific domain:**  ```sh  ./devopsfetch.sh -n <domain>  ```-<br /> **List all users and their last login times:**  ```sh  ./devopsfetch.sh -u  ```-<br /> **Provide detailed information about a specific user:**  ```sh  ./devopsfetch.sh -u <username>  ```-<br /> **Display activities within a specified time range:**  ```sh  ./devopsfetch.sh -t  ```

## 3. Command Line Flags
| Flag           | Description                                                              |
|-----------------------|-------------------------------------------------------------------|
| `-p` or `--port`      | Display all active ports and services                             |
| `-p <port_number>`    | Provide detailed information about a specific port                |
| `-d` or `--docker`    | List all Docker images and containers                             |
| `-d <container_name>` | Provide detailed information about a specific container           |
| `-n` or `--nginx`     | Display all Nginx domains and their ports                         |
| `-n <domain>`         | Provide detailed configuration information for a specific domain  |
| `-u` or `--users`     | List all users and their last login times                         |
| `-u <username>`       | Provide detailed information about a specific user                |
| `-t` or `--time`      | Display activities within a specified time range                  |
| `-h` or `--help`      | Display help information                                          |

## 4. Continuous Monitoring
### devopsfetch_monitor.sh This script is designed to run continuously in the background to monitor and log system activities.
- **Log File Location:** `/var/log/devopsfetch.log`- **Log Rotation:** Ensures the log file does not exceed a certain size (e.g., 10 MB).
### Steps- **Create a `systemd` Service File:**  ```sh 
  [Unit]  Description=DevOpsFetch Monitoring Service<br />[Service]  ExecStart=/path/to/devopsfetch_monitor.sh  Restart=always<br />[Install]  WantedBy=multi-user.target  ```
- **Enable and Start the Service:** 
```sh  sudo systemctl enable devopsfetch.service && sudo systemctl start devopsfetch.service```

## 5. Log RotationThe `devopsfetch_monitor.sh` script includes a mechanism to ensure log rotation. When the log file exceeds a certain size (e.g., 10 MB), it renames the current log file and starts a new one.

### Example Log Rotation Code```shMAX_LOG_SIZE=10485760  # 10 MB
while true; do   <br /> current_size=$(stat -c%s "$LOG_FILE")  <br />  if [ "$current_size" -ge "$MAX_LOG_SIZE" ]; then  <br /> mv "$LOG_FILE" "$LOG_FILE.$(date +%Y%m%d%H%M%S)"  <br />  fi  <br /> sleep 60 <br /> done```

## 6. Help and Documentation

### Display Help InformationUse the `-h` or `--help` flag to display usage instructions for the `devopsfetch.sh` script.
```sh./devopsfetch.sh -h```
### Comprehensive Documentation. The documentation covers:-<br /> **Installation and Configuration Steps:** <br />How to install dependencies and set up the `systemd` service.-<br /> **Usage Examples:** <br />Detailed examples for each command-line flag.-<br /> **Logging Mechanism:** Explanation of how the logging works and how to retrieve logs.

This documentation provides an overview of the DevOpsFetch tool, its scripts, and detailed instructions for installation, usage, and configuration.