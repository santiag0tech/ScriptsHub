#!/bin/bash

# Check if the current user is root
if [ `id -u` != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Ask the user to enter the group name
read -p "Enter the name of the group: " GROUP_NAME

# Ask the user to enter the sequence of user names
read -p "Enter the sequence of user names (e.g., user1 user2): " USERS

# Ask the user to enter the starting number of the sequence
read -p "Enter the starting number of the sequence: " START_NUMBER

# Ask the user to enter the maximum number of the sequence
read -p "Enter the maximum number of the sequence: " MAX_NUMBER

# Calculate the length of the maximum number
MAX_LENGTH=${#MAX_NUMBER}

# Format the sequence according to specifications
SEQUENCE=`seq -f%0${MAX_LENGTH}g $START_NUMBER $MAX_NUMBER`

if ! cat /etc/group | cut -d: -f1 | grep -q "^$GROUP_NAME$"; then
   groupadd $GROUP_NAME
fi

# Loop through each name in the sequence provided by the user
for USER in $USERS
do
   # Print status message
   echo "Creating prerequisites for $USER"
   groupadd $USER
   mkdir -p /home/$GROUP_NAME/$USER 2>/dev/null

   # Loop through the sequence
   for NUM in $SEQUENCE
   do
      USER_NAME=$USER$NUM
      PASSWORD=$USER_NAME
      USER_HOME=/home/$GROUP_NAME/$USER/$USER_NAME
 
      # Create user
      echo "Creating user: $USER_NAME"
      useradd -g $USER -G $GROUP_NAME -m -d $USER_HOME $USER_NAME
      (echo $PASSWORD; echo $PASSWORD) | passwd $USER_NAME >/dev/null 2>&1

      # Expire password immediately
      passwd -e $USER_NAME >/dev/null 2>&1
   done
done
