#!/bin/bash

# Function to transfer files
transfer_files() {
  # Set remote server information
  remote_server=""
  username=""
  local_file=""
  remote_file=""
  ssh_key=""

  # Check if the local file exists
  if [ ! -f "$local_file" ]; then
    echo "Error: The local file $local_file does not exist."
    return 1
  fi

  # Transfer file
  scp -i "$ssh_key" "$local_file" "$username@$remote_server:$remote_file"

  # Check if the transfer was successful
  if [ $? -eq 0 ]; then
    echo "File $local_file transferred to $remote_server"
  else
    echo "Error: Failed to transfer file $local_file to $remote_server"
    return 1
  fi
}

# Call the function
transfer_files
