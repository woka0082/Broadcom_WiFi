This guide explains how to install Broadcom-wl (or its dkms variant) on Arch Linux.

There are two scripts provided:

    install_broadcom_wifi.sh: This script installs dkms after Arch Linux has been installed. It requires an internet connection.

    install_broadcom.sh: This script attempts to install either Broadcom-wl or Broadcom-wl-dkms during the Arch installation process. However, this script is no longer necessary, as broadcom-wl is now included in the Arch ISO by default. Still, the script remains a useful alternative. That said, most users will likely prefer dkms for long-term stability and easier updates.

To activate Broadcom-wl during the Arch installation, use the script activate_broad_wl.sh, then to set up a Wi-Fi connection, run connect_wifi.sh.
