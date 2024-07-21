#!/bin/bash

# Function to prompt for the Wineskin Installer & Select its Directory
select_wineskin() {
    read -r -e -p "Please enter the path to the MapleLegends Wineskin file: " ml_wineskin_user_input

    # Expand full file path from input
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
        echo "ERR 2: Your input does not contain a valid MapleLegends package. Make sure you are using the Wineskin Installer from the forums."
        exit 1
    fi
}

# Call the function to select the Wineskin
select_wineskin

# Function to prompt the user for the MapleLegends installation directory and handle overwrite option
install_prompt() {
    # Prompt the User for the MapleLegends Installation Directory
    read -r -e -p "Please enter the installation directory for MapleLegends (leave blank for \"$HOME\"): " ml_install_dir_user_input
    # Expand full file path from input
    if [[ -n "$ml_install_dir_user_input" ]]; then
        ml_install_dir=$(eval "echo $ml_install_dir_user_input")
    fi
    # Use the home directory as default if input is blank
    if [[ -z "$ml_install_dir_user_input" ]]; then
        ml_install_dir="$HOME/MapleLegends"
    fi
    # Check if the MapleLegends installation directory already exists
    if [[ -d "$ml_install_dir" ]]; then
        echo "The MapleLegends installation directory already exists."
        while true; do
            read -r -e -p "Do you want to overwrite the existing MapleLegends installation directory? (yes/no): " overwrite
            case $overwrite in
            yes|no)
                break
                ;;
            *)
                echo "Invalid input. Please enter 'yes' or 'no'."
                ;;
            esac
        done
    fi
    # If overwrite is set to yes, remove the existing MapleLegends installation directory
     if [[ "$overwrite" == "yes" ]]; then
        echo "Overwriting the MapleLegends installation directory."
        rm -rf "$ml_install_dir"
        mkdir -p "$ml_install_dir"
        echo "Overwritten the MapleLegends installation directory."
    elif [[ -z "$overwrite" ]]; then
        echo "Skipping the overwrite process."&
    elif [[ "$overwrite" == "no" ]]; then
        echo "Please overwrite the directory or select a new one."
        install_prompt        
    else
        echo "ERR 4: Invalid input. Please type 'yes' to overwrite or 'no' to exit."
        rm -rf "$ml_install_dir"
        exit 1
    fi
    # Create the MapleLegends installation directory if unmade
    if [[ ! -d "$ml_install_dir" ]]; then
        mkdir -p "$ml_install_dir"
        echo "Created the MapleLegends installation directory."
    fi
    echo "The MapleLegends installation directory is set to: $ml_install_dir"
    echo "Now Installing . . ."
}

# Call the install_prompt function
install_prompt

# Function to check dependencies and install them if needed
dep_check() {
    # Check Distro
    if [[ -f /etc/os-release ]]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        OS=$NAME
        echo "Detected OS: $OS"
    else
        echo "Not able to determine OS"
        exit 1
    fi

# Function to create a fun animation
msg_dep_1() {
    echo "Checking for dependencies . . ."
    sleep 5
    echo "You'll need the following dependencies: bash, p7zip, wget, wine, winetricks, and corefonts."
}

# Call the animate function
msg_dep_1

# Function to animate the dependency check
msg_dep_2() {
    echo "Please enter your password if prompted to install from your local package manager."
    sleep 5
    echo "Installing dependencies now . . ."
}

# Call the animate_dep_2 function
msg_dep_2

# Grab Dependencies
    case $OS in
    "Ubuntu"|"Linux Mint")
        sudo apt-get update
        sudo apt-get install -y bash p7zip-full wget wine winetricks
        ;;
    "Fedora")
        sudo dnf install -y bash p7zip p7zip-plugins wget wine winetricks
        ;;
    "Manjaro Linux"|"Arch Linux"|"steamos")  # Include "steamos" here
        sudo pacman -Syu --noconfirm bash p7zip wget wine winetricks
        ;;
    "Gentoo")
        sudo emerge --update --newuse app-arch/p7zip net-misc/wget app-emulation/wine app-emulation/winetricks
        ;;
    *)
        echo "This Linux distribution ($OS) is not specifically checked for in this script. Please manually install: bash, p7zip, wget, wine, winetricks, and corefonts."
        ;;
    esac
}

# Call the dep_check function
dep_check

# Function to create temporary install directory, copy wineskin, extract Wineskin, and detect MapleLegends Program Files folder
setup_installation() {
    # Create the temporary install directory
    install_dir=$(mktemp -d -t ml_installer.XXXXXXXXXX)
    echo "Created temporary install directory: $install_dir"

    # Copy the wineskin to the temporary install directory
    if [[ -f "$ml_wineskin" ]]; then
        eval "cp $ml_wineskin $install_dir"
        echo "Copied the MapleLegends Wineskin to the temporary install directory."
    else
        echo "ERR 2: Unable to create the tmp environment. Ensure the script has access to /tmp/."
        exit 1
    fi

    # Extract the Wineskin
    cd "$install_dir" || exit
    echo "Extracting the MapleLegends Wineskin."

    # Extract the Package File using 7z silently
    7z x -y MapleLegends-*.pkg > /dev/null
    # Extract the Payload silently
    7z x -y Payload* > /dev/null

    # Detect MapleLegends Program Files Folder
    ml_program_files=$(find . -type d -name "MapleLegends" | head -n 1)

    if [[ -d "$ml_program_files" ]]; then
        echo "MapleLegends Program Files folder detected! It can be found at $ml_program_files"
    else
        echo "ERR 3: Unable to detect the MapleLegends Program Files folder. Make sure you are using the Wineskin Installer from the forums."
        exit 1
    fi
}

# Call the function to set up the installation
setup_installation

# Function to move the MapleLegends Program Files to the installation directory and clean up the temporary install directory
move_files_and_cleanup() {
    # Move the MapleLegends Program Files to the installation directory
    echo "Now Moving the MapleLegends Program Files to the installation directory."
    mv "$ml_program_files" "$ml_install_dir"
    echo "Moved the MapleLegends Program Files to the installation directory."

    # Clean up the temporary install directory
    echo "Cleaning up the temporary install directory."
    rm -rf "$install_dir"
}

# Call the function to move files and clean up
move_files_and_cleanup

# Function to set up Wine and download the patched ws2_32.dll
setup_wine() {
    # Warn the user that we're going to set up wine.
    echo "Setting up Wine... We're downloading corefonts so this might take a while . . ."

    # Set the default Windows version to Windows 98
    mkdir "$ml_install_dir/wine"
    WINEPREFIX="$ml_install_dir/wine" WINEARCH="win32" winetricks win98 corefonts > /dev/null 2>&1


    # Check the Wine Install Directory
    if [[ -d "$ml_install_dir/wine" ]]; then
        echo "Wine has been successfully set up."
    else
        echo "ERR 5: Wine Install Failure. Please check the syslog for errors."
        exit 1
    fi
    }

# Call the function to set up Wine and download the patched ws2_32.dll
setup_wine

# Set up the patched ws2_32.dll in the wine install
setup_ws232dll() {    
    echo "Setting up the patched ws2_32.dll in the Wine install."
    rm -f "$ml_install_dir/wine/drive_c/windows/system32/ws2_32.dll"
    rm -f "$ml_install_dir/wine/drive_c/windows/system32/ws2help.dll"
    # Download the patched ws2_32.dll
    cd "$ml_install_dir/wine/drive_c/windows/system32" || exit
    echo "Downloading the patched ws2_32.dll."
    tmp_dir=$(mktemp -d)
    cd "$tmp_dir" || exit
    wget -q -N https://raw.githubusercontent.com/avidous/legendslinuxinstaller/main/ws2dlls/ws2_32.dll
    wget -q -N https://raw.githubusercontent.com/avidous/legendslinuxinstaller/main/ws2dlls/ws2help.dll
    mv -f ws2_32.dll "$ml_install_dir/wine/drive_c/windows/system32/"
    mv -f ws2help.dll "$ml_install_dir/wine/drive_c/windows/system32/"
    cd - || exit
    rm -rf "$tmp_dir"
    # Check if the ws2help.dll was downloaded successfully
    if [[ -f "$ml_install_dir/wine/drive_c/windows/system32/ws2help.dll" ]]; then
        echo "The patched ws2_32.dll has been downloaded successfully."
    else
        echo "ERR 6: Unable to download the patched ws2_32.dll. Please check your internet connection."
        exit 1
    fi
}
# Call the function to set up the patched ws2_32.dll
setup_ws232dll

#Set up the start script
setup_start_script() {
    echo "Setting up the start script."
# Create the start script
touch "$ml_install_dir/startlegends.sh"
cat <<EOF > "$ml_install_dir/startlegends.sh"
#!/bin/bash

# Set the Wine prefix
export WINEPREFIX="$ml_install_dir/wine"
export WINEARCH="win32"
export WINEDLLOVERRIDES="mscoree,mshtml="

# Run MapleLegends.exe using Wine
cd "$ml_install_dir/MapleLegends/" || exit
wine MapleLegends.exe > /dev/null 2>&1 &
EOF
chmod +x "$ml_install_dir/startlegends.sh"
}
# Call the function to set up the start script
setup_start_script

# Function to ask user if they'd like to run the game now
run_game_prompt() {
    read -r -p "Would you like to run MapleLegends now? (yes/no): " run_now
    case $run_now in
        yes)
            echo "Running MapleLegends..."
            cd "$ml_install_dir" || exit
            ./startlegends.sh
            ;;
        no)
            echo "MapleLegends has been installed successfully. You can run it later using the startlegends.sh script in the installation directory."
            ;;
        *)
            echo "Invalid input. Please type 'yes' to run MapleLegends now or 'no' to exit."
            run_game_prompt
            ;;
    esac
}

# Call the function to ask user if they'd like to run the game now
run_game_prompt
exit 0