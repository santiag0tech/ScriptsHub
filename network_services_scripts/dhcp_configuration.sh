#!/bin/bash

# Check if script is running as root
if [ `id -u` -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

configure_dhcp_server() {
    # Prompt user input for DHCP server configuration
    read -p "Network interface name where DHCP server will run (e.g., eth0, enp0s8): " interface
    read -p "Subnet address: " subnet
    read -p "Starting IP address for DHCP pool: " pool_start
    read -p "Ending IP address for DHCP pool: " pool_end
    read -p "Subnet mask in dotted decimal format (e.g., 255.255.255.0): " subnet_mask
    read -p "Default gateway: " gateway
    read -p "DNS servers (comma-separated, e.g., 8.8.8.8,8.8.4.4): " dns_servers

    # Update DHCP configuration file
    echo "subnet $subnet netmask $subnet_mask {" > /etc/dhcp/dhcpd.conf
    echo "    range $pool_start $pool_end;" >> /etc/dhcp/dhcpd.conf
    echo "    option routers $gateway;" >> /etc/dhcp/dhcpd.conf
    echo "    option domain-name-servers $dns_servers;" >> /etc/dhcp/dhcpd.conf
    echo "}" >> /etc/dhcp/dhcpd.conf

    # Restart DHCP service
    systemctl restart dhcpd

    echo "DHCP server configured and restarted on interface $interface"
    echo "Subnet: $subnet"
    echo "IP address pool: $pool_start - $pool_end"
    echo "Subnet mask: $subnet_mask"
    echo "Default gateway: $gateway"
    echo "DNS servers: $dns_servers"
}

# Call DHCP server configuration function
configure_dhcp_server
