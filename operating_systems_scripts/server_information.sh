#!/bin/bash

# Function to display the main menu
function show_menu(){
    date
    echo "---------------------"
    echo "  System Monitoring"
    echo "---------------------"
    echo "1. Disk Usage"                      # Option to display disk usage
    echo "2. System Users"                   # Option to display system users
    echo "3. Network Connections"            # Option to display network connections
    echo "4. CPU Usage"                      # Option to display CPU usage
    echo "5. Memory Usage"                   # Option to display memory usage
    echo "6. Processes"                      # Option to display processes
    echo "7. Mounted Filesystems"            # Option to display mounted filesystems
    echo "8. Hardware Information"           # Option to display hardware information
    echo "9. System Uptime"                  # Option to display system uptime
    echo "10. Kernel Version"                # Option to display kernel version
    echo "11. Exit"                          # Option to exit the program
}

# Function to read user input and execute corresponding functions
function read_input(){
    local choice
    read -p "Enter your choice [1-11]: " choice
    case $choice in
        1) disk_usage ;;                   # Execute disk_usage function
        2) system_users ;;                 # Execute system_users function
        3) network_connections ;;          # Execute network_connections function
        4) cpu_usage ;;                    # Execute cpu_usage function
        5) memory_usage ;;                 # Execute memory_usage function
        6) processes ;;                    # Execute processes function
        7) mounted_filesystems ;;          # Execute mounted_filesystems function
        8) hardware_info ;;                # Execute hardware_info function
        9) system_uptime ;;                # Execute system_uptime function
        10) kernel_version ;;              # Execute kernel_version function
        11) echo "Bye!"; exit 0 ;;         # Exit the program
        *) echo "Invalid choice. Please enter a number between 1 and 11." ;;   # Error message for invalid input
    esac
    pause
}

# Function to display disk usage
function disk_usage(){
    df -h                               # Display disk usage information
}

# Function to display system users
function system_users(){
    cat /etc/passwd | cut -d: -f1       # Display system users
}

# Function to display network connections
function network_connections(){
    ss -tunapl                          # Display network connections
}

# Function to display CPU usage
function cpu_usage(){
    top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'   # Display CPU usage
}

# Function to display memory usage
function memory_usage(){
    free -m                             # Display memory usage
}

# Function to display processes
function processes(){
    pstree                              # Display processes
}

# Function to display mounted filesystems
function mounted_filesystems(){
    mount                               # Display mounted filesystems
}

# Function to display hardware information
function hardware_info(){
    lshw                                # Display hardware information
}

# Function to display system uptime
function system_uptime(){
    uptime                              # Display system uptime
}

# Function to display kernel version
function kernel_version(){
    uname -a                            # Display kernel version
}

# Function to pause and wait for user input
function pause(){
    read -p "Press [Enter] key to continue..."
}

# Main program loop
while true
do
    clear                               # Clear the screen
    show_menu                           # Display the main menu
    read_input                          # Read user input and execute corresponding functions
done
