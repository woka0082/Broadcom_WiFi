#!/bin/bash

# Check if the 'wl' module is already loaded
lsmod | grep wl

# Remove conflicting modules to avoid issues with Broadcom's wl driver
echo "Removing conflicting modules..."
rmmod b43 b43legacy bcm43xx bcma brcm80211 brcmfmac brcmsmac ssb

# Reload the wl module to ensure it's active and functioning
echo "Reloading wl module..."
rmmod wl
modprobe wl

# Restart iwd to allow iwctl to recognize the WiFi device, such as wlan0,
echo "Restarting iwd service..."
systemctl restart iwd

echo "Setup complete. You should now be able to use iwctl to manage WiFi connections."
