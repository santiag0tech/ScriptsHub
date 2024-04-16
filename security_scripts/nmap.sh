#!/bin/bash

# Check if the user has superuser privileges
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Function to show the menu options
show_menu() {
    echo "Select an option:"
    echo "1. Scan a single host"
    echo "2. Scan an entire network"
    echo "3. Scan a port range on a host"
    echo "4. Scan known ports on a host"
    echo "5. Scan with OS detection and service version"
    echo "6. Scan with security scripts"
    echo "7. Exit"
}

# Function to scan a single host
scan_single_host() {
    read -p "Enter the target host's IP address to scan: " target_ip
    nmap $target_ip
}

# Function to scan an entire network
scan_whole_network() {
    read -p "Enter the network address in CIDR format (e.g., 192.168.1.0/24): " network
    nmap -sP $network
}

# Function to scan a port range on a host
scan_port_range() {
    read -p "Enter the target host's IP address to scan: " target_ip
    read -p "Enter the port range to scan (e.g., 1-1000): " port_range
    nmap -p $port_range $target_ip
}

# Function to scan known ports on a host
scan_known_ports() {
    read -p "Enter the target host's IP address to scan: " target_ip
    nmap -F $target_ip
}

# Function to scan with OS detection and service version
scan_os_version() {
    read -p "Enter the target host's IP address to scan: " target_ip
    nmap -A $target_ip
}

# Function to scan with security scripts
scan_security_scripts() {
    read -p "Enter the target host's IP address to scan: " target_ip
    nmap --script security $target_ip
}

# Loop to show the menu until the user selects to exit
while true; do
    show_menu
    read -p "Option: " option
    case "$option" in
        1)
            scan_single_host
            ;;
        2)
            scan_whole_network
            ;;
        3)
            scan_port_range
            ;;
        4)
            scan_known_ports
            ;;
        5)
            scan_os_version
            ;;
        6)
            scan_security_scripts
            ;;
        7)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
done
