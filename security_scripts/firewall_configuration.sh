#!/bin/bash

# Check if the user has superuser privileges
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Ask the user if they want to configure rules for a network or just an IP
read -p "Do you want to configure rules for a network (N) or just an IP (I)? [N/I]: " network_type

# Validate user's response
if [ "$network_type" == "N" ] || [ "$network_type" == "n" ]; then
    read -p "Enter the network address in CIDR format (e.g., 192.168.1.0/24): " network
elif [ "$network_type" == "I" ] || [ "$network_type" == "i" ]; then
    read -p "Enter the IP address: " ip_address
else
    echo "Invalid response. Exiting..."
    exit 1
fi

# Ask for the ports to be allowed
read -p "Enter the ports you want to allow (comma-separated): " allowed_ports

# Flush existing rules
iptables -F
iptables -X

# Set the default policy to DROP
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

# Allow related or established connections
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Allow user-specified traffic
if [ "$network_type" == "N" ] || [ "$network_type" == "n" ]; then
    iptables -A INPUT -s "$network" -p tcp -m multiport --dports "$allowed_ports" -j ACCEPT
    iptables -A INPUT -s "$network" -p udp -m multiport --dports "$allowed_ports" -j ACCEPT
    iptables -A OUTPUT -d "$network" -p tcp -m multiport --dports "$allowed_ports" -j ACCEPT
    iptables -A OUTPUT -d "$network" -p udp -m multiport --dports "$allowed_ports" -j ACCEPT
    
    # Allow ping (ICMP) from and to the specified network
    iptables -A INPUT -s "$network" -p icmp --icmp-type echo-request -j ACCEPT
    iptables -A OUTPUT -d "$network" -p icmp --icmp-type echo-reply -j ACCEPT
elif [ "$network_type" == "I" ] || [ "$network_type" == "i" ]; then
    iptables -A INPUT -s "$ip_address" -p tcp -m multiport --dports "$allowed_ports" -j ACCEPT
    iptables -A INPUT -s "$ip_address" -p udp -m multiport --dports "$allowed_ports" -j ACCEPT
    iptables -A OUTPUT -d "$ip_address" -p tcp -m multiport --dports "$allowed_ports" -j ACCEPT
    iptables -A OUTPUT -d "$ip_address" -p udp -m multiport --dports "$allowed_ports" -j ACCEPT
    
    # Allow ping (ICMP) from and to the specified IP address
    iptables -A INPUT -s "$ip_address" -p icmp --icmp-type echo-request -j ACCEPT
    iptables -A OUTPUT -d "$ip_address" -p icmp --icmp-type echo-reply -j ACCEPT
fi

# Show configured rules
echo "iptables rules have been configured:"
iptables -L -n

echo "Configuration completed!"
