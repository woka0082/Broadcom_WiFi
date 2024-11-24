#!/bin/bash

# Prompt for WiFi network name and password
echo "Enter the WiFi network name (SSID):"
read -r SSID
echo "Enter the WiFi password:"
read -rs PASSWORD  # -s hides the input for security

# Detect the wireless interface
INTERFACE=$(iwctl device list | awk '/station/ {print $2}')

# Check if a wireless device was found
if [[ -z $INTERFACE ]]; then
    echo "No wireless device found. Please make sure your WiFi adapter is detected."
    exit 1
fi

echo "Wireless device detected: $INTERFACE"

# Scan for networks,
echo "Scanning for networks..."
iwctl station "$INTERFACE" scan
sleep 5

# Attempt to connect, retrying up to 3 times if necessary
for i in {1..3}; do
    echo "Attempting to connect to $SSID (Attempt $i)..."
    iwctl station "$INTERFACE" connect "$SSID" --passphrase "$PASSWORD"

    # Check if connection was successful
    if [[ $? -eq 0 ]]; then
        echo "Successfully connected to $SSID!"
        exit 0
    fi

    echo "Failed attempt $i, retrying..."
    sleep 5  # Wait 5 seconds before retrying
done

# If all attempts fail
echo "Failed to connect to $SSID after 3 attempts."
exit 1
