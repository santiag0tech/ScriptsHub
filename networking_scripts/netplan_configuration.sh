#!/bin/bash

# Check if the user has superuser privileges
if [ `id -u` != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Function to show the menu options
show_menu() {
    echo "Select an option:"
    echo "1. Configure network interface"
    echo "2. Exit"
}

# Function to configure the network interface
configure_network_interface() {
    read -p "Enter the name of the network interface (e.g., ens33, enp0s9): " interface
    read -p "Do you want to use DHCP? (y/n): " dhcp_option
    case "$dhcp_option" in
        [yY]*)
            dhcp=true
            ;;
        [nN]*)
            dhcp=false
            read -p "Enter the IP address: " ip_address
            read -p "Enter the subnet mask (e.g. 24, 16, 8): " subnet_mask
            read -p "Enter the gateway: " gateway
            read -p "Enter the DNS servers (comma-separated): " dns_servers
            ;;
        *)
            echo "Invalid option."
            ;;
    esac

    # Generate the Netplan configuration
    netplan_config="\
network:
  version: 2
  renderer: networkd
  ethernets:
    $interface:
      dhcp4: $dhcp
"

    # Add additional configuration if not using DHCP
    if [ "$dhcp" = false ]; then
        netplan_config+="\
      addresses: [$ip_address/$subnet_mask]
      gateway4: $gateway
      nameservers:
        addresses: [$dns_servers]
"
    fi

    # Save the configuration to the Netplan configuration file
    echo "$netplan_config" > /etc/netplan/01-network-manager-all.yaml

    # Apply the Netplan configuration
    netplan apply

    echo "--------------------------------------------"
    echo "Netplan configuration applied successfully."
}

# Loop to show the menu until the user selects to exit
while true; do
    show_menu
    read -p "Option: " option
    case "$option" in
        1)
            configure_network_interface
            ;;
        2)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
done
