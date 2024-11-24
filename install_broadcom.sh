#!/bin/bash

# Function to install Broadcom driver (either non-DKMS or DKMS version)
install_broadcom() {
    local driver_package=$1
    local dkms_check=$2

# update repo
pacman -Sy

    # Install necessary dependencies (linux-headers)
    echo "Installing linux-headers..."
    pacman -S --noconfirm linux-headers

    # Check if DKMS is required and install it if not already installed
    if [ "$dkms_check" == "dkms" ]; then
        if ! pacman -Qi dkms &>/dev/null; then
            echo "DKMS is not installed. Installing DKMS..."
            pacman -S --noconfirm dkms
        fi
    fi

    # Install the Broadcom driver (either broadcom-wl or broadcom-wl-dkms)
    echo "Installing $driver_package..."
    pacman -S --noconfirm "$driver_package"

    # Unload any conflicting drivers (like b43)
    echo "Unloading conflicting drivers (b43)..."
    rmmod b43 b43legacy bcm43xx bcma brcm80211 brcmfmac brcmsmac ssb

    # Load the Broadcom Wi-Fi driver
    echo "Loading Broadcom wl driver..."
    modprobe wl

    # Verify if the driver is successfully loaded
    if lsmod | grep -q "wl"; then
        echo "Broadcom wl driver is successfully loaded!"
    else
        echo "Failed to load Broadcom wl driver."
        exit 1
    fi

    # Check network interfaces
    echo "Listing network interfaces..."
    ip link show

    # Notify user to connect to Wi-Fi
    echo "You can now use iwctl or NetworkManager to connect to Wi-Fi."
}

# Prompt user for choice and call the installation function accordingly
echo "Choose which Broadcom driver to install:"
echo "1. broadcom-wl (non-DKMS version)"
echo "2. broadcom-wl-dkms (DKMS version)"

read -p "Enter your choice (1 or 2): " choice

case $choice in
    1)
        install_broadcom "broadcom-wl" ""
        ;;
    2)
        install_broadcom "broadcom-wl-dkms" "dkms"
        ;;
    *)
        echo "Invalid choice. Please choose 1 or 2."
        exit 1
        ;;
esac

