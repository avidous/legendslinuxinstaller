#!/bin/bash

# Prompt for the Wineskin Installer & Select its Directory
read -r -e -p "Please enter the path to the MapleLegends Wineskin file: " ml_wineskin_user_input

#Expand full file path from input
ml_wineskin_location=$(eval "echo $ml_wineskin_user_input")

# Check if the provided path exists and is a file
if [[ -f "$ml_wineskin_location" ]]; then
    ml_wineskin="$ml_wineskin_location"
    echo "The variable contains the path to a valid MapleLegends Wineskin file."
else
    echo "ERR 1: The provided path does not exist or is not a file. Make sure you enter the correct path to the Wineskin file."
    exit 1
fi

# Check if the Wineskin is a valid MapleLegends package
if [[ "$ml_wineskin" == *"MapleLegends-"*.pkg ]]; then
    echo "The variable contains a valid MapleLegends package."
else
    echo "ERR 2: Your  input does not contain a valid MapleLegends package. Make sure you are using the Wineskin Installer from the forums."
    exit 1
fi

# Check Distro
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    OS=$NAME
else
    echo "Not able to determine OS"
    exit 1
fi

# Grab Dependencies
# To-Do: Write out the list of dependencies below and write the proper dependency check for each distro.

case $OS in
"Ubuntu")
    echo "This is Ubuntu."
    ;;
"Fedora")
    echo "This is Fedora."
    ;;
"Manjaro Linux")
    echo "This is Manjaro Linux."
    ;;
"Arch Linux")
    echo "This is Arch Linux."
    ;;
"Gentoo")
    echo "This is Gentoo."
    ;;
"steamos")
    echo "This is SteamOS."
    ;;
"Linux Mint")
    echo "This is Linux Mint."
    ;;
*)
    echo "This Linux distribution ($OS) is not specifically checked for in this script."
    ;;
esac

# Create the temporary install directory
install_dir=$(mktemp -d -t ml_installer.XXXXXXXXXX)
echo "Created temporary install directory: $install_dir"

#Copy the wineskin to the temporary install directory
if [[ -f "$ml_wineskin" ]]; then
    eval "cp $ml_wineskin $install_dir"
    echo "Copied the MapleLegends Wineskin to the temporary install directory."
else
    echo "ERR 2: Unable to create the tmp environment. Ensure the script has access to /tmp/."
    exit 1
fi

#Extract the Wineskin
cd "$install_dir" || exit
echo "Extracting the MapleLegends Wineskin."

#Extract the Package File using 7z
7z x MapleLegends-*.pkg
#Extract the Payload
7z x Payload*

#Detect MapleLegends Program Files Folder
ml_program_files=$(find . -type d -name "MapleLegends" | head -n 1)

if [[ -d "$ml_program_files" ]]; then
    echo "MapleLegends Program Files folder detected! It can be found at $ml_program_files"
else
    echo "ERR 3: Unable to detect the MapleLegends Program Files folder. Make sure you are using the Wineskin Installer from the forums."
    exit 1
fi

#Prompt the User for the MapleLegends Installation Directory
read -r -e -p "Please enter the installation directory for MapleLegends (leave blank for default): " ml_install_dir_user_input

# Use the home directory as default if input is blank
if [[ -z "$ml_install_dir_user_input" ]]; then
    ml_install_dir="$HOME/MapleLegends"
else
    ml_install_dir="$ml_install_dir_user_input"
fi

echo "The MapleLegends installation directory is set to: $ml_install_dir"

# Create the MapleLegends installation directory
if [[ ! -d "$ml_install_dir" ]]; then
    mkdir -p "$ml_install_dir"
    echo "Created the MapleLegends installation directory."
else
    echo "ERR 4: The MapleLegends installation directory already exists. Please choose a different directory."
    exit 1
fi

# mv the MapleLegends Program Files to the installation directory
echo "Now Moving the MapleLegends Program Files to the installation directory."
mv "$ml_program_files" "$ml_install_dir"
echo "Moved the MapleLegends Program Files to the installation directory."

# Clean up the temporary install directory
echo "Cleaning up the temporary install directory."
rm -rf "$install_dir"

# Warn the user that we're going to set up wine.
echo "Setting up Wine..."
mkdir "$ml_install_dir/wine"

# Set the default Windows version to Windows 98
WINEPREFIX="$ml_install_dir/wine" WINEARCH="win32" winetricks win98

#Check the Wine Install Directory
if [[ -d "$ml_install_dir/wine" ]]; then
    echo "Wine has been successfully set up."
else
    echo "ERR 5: Wine Install Failure. Please check the syslog for errors."
    exit 1
fi