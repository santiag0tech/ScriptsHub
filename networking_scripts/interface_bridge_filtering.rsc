{
    # Define the interfaces
    :local checkInterfaces ""
    :local listInterfaces [:toarray [:tostr $checkInterfaces]]

    # Iterate over each interface in the list
    :foreach singleInterface in=$listInterfaces do={
        :local count [/interface bridge host find where on-interface=$singleInterface external=yes]
        :local recordCount [:len $count]

        # Check if there are more than one MAC address associated with the interface
        :if ($recordCount > 1) do={
            :put ("Interface $singleInterface has $recordCount MAC addresses associated. Blocking the MAC addresses...")
            /interface bridge filter add chain=input in-interface=$singleInterface action=drop 
        } else={
            :put ("Interface $singleInterface does not exist or has no MAC addresses associated.")
        }
    }
}
