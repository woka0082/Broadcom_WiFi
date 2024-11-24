# This is to install the Broadcom WiFi on the old iMac after the Arch installation

#!/bin/bash

# Function to check for Broadcom chipset
check_broadcom_chipset() {
    lspci | grep -i "broadcom"
}

# Get Broadcom chipset information
broadcom_chipset=$(check_broadcom_chipset)

if [[ -z $broadcom_chipset ]]; then
    echo "No Broadcom Wi-Fi chipset found."
    exit 1
fi

# Show chipset information
echo "Found Broadcom Wi-Fi chipset:"
echo "$broadcom_chipset"

# Ask for confirmation to continue
read -p "Do you want to continue with the installation? (y/N): " answer
answer=${answer,,} # Convert to lowercase

if [[ "$answer" != "y" ]]; then
    echo "Aborting installation."
    exit 0
fi

# Update the package database and install the necessary packages
echo "Installing linux-headers and broadcom-wl-dkms..."
sudo pacman -Syu linux-headers broadcom-wl-dkms --noconfirm

# Update the initial ramdisk
echo "Updating the initial ramdisk..."
sudo mkinitcpio -p linux

# Blacklist the conflicting drivers
echo "Blacklisting conflicting drivers..."
sudo rmmod b43 b43legacy bcm43xx bcma brcm80211 brcmfmac brcmsmac ssb

# Load the Broadcom driver
echo "Loading the Broadcom driver..."
sudo modprobe wl

echo "Installation complete. Please restart your network service or reboot your computer."
