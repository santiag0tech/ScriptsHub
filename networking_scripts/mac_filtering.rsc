# Remove all previous rules
/interface bridge filter remove [find]

{
    # Define variables
    :local interfaceListName ""
    :local servicePortsList ""

    # Add interface list including service ports
    /interface list
    add include=$servicePortsList name=$interfaceListName

    # Allow traffic for service ports
    /interface bridge filter
    add action=accept chain=input in-interface-list=$interfaceListName
}

# Find all MAC addresses associated with the external bridge interface and allow traffic from existing MAC addresses
:foreach mac in=[/interface bridge host find where external=yes] do={
    :local macAddress [/interface bridge host get $mac mac-address]
    /interface bridge filter add chain=input src-mac-address="$macAddress/FF:FF:FF:FF:FF:FF" action=accept
}

# Last action to deny the rest
/interface bridge filter add chain=input action=drop
