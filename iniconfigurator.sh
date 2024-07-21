#!/bin/bash

# Interactive Bash Script to Edit Legends INI Configuration

#Script to autodetect in the home folder the full path of the Legends.ini file and store to variable
legends_ini=$(find ~ -type f -name "Legends.ini" 2>/dev/null | head -n 1)

if [ -z "$legends_ini" ]; then
    echo "Unable to find Legends.ini file."
    read -r -p "Please enter the path to the Legends.ini file: " legends_ini
fi

while [ ! -f "$legends_ini" ]; do
    echo "Invalid file path. Please try again."
    read -r -p "Please enter the path to the Legends.ini file: " legends_ini
done

#Verify the legends.ini file with the user before proceeeding.
echo "Legends.ini file found at: $legends_ini"
read -p "Do you want to proceed with this file? (y/n): " choice

if [ "$choice" != "y" ]; then
    read -r -p "Please enter the path to the Legends.ini file: " legends_ini
fi

# ENTER THE CONFIGURATOR

CONFIG_FILE="$legends_ini"

function update_config() {
    local section=$1
    local key=$2
    local value=$3

    sed -i "s/^\($key\s*=\s*\).*$/\1$value/" "$CONFIG_FILE"
    echo "Updated $key in $section section with $value"
}


function edit_hd_client() {
    echo "Select your resolution for Legends:"
    echo "0 = 800x600"
    echo "1 = 1024x768"
    echo "2 = 1366x768 (Unstable on MAC)"
    read -p "Enter your choice (0/1/2): " choice

    case $choice in
        0|1|2)
            update_config "APPEARANCE" "HDClient" "$choice"
            ;;
        *)
            echo "Invalid input. Please try again."
            edit_hd_client
            ;;
    esac
}

function edit_windowed_mode() {
    read -r -p "Run client in windowed mode? (true/false): " choice

    case $choice in
        true|false)
            update_config "APPEARANCE" "Windowed" "$choice"
            ;;
        *)
            echo "Invalid input. Please try again."
            edit_windowed_mode
            ;;
    esac
}

function edit_dark_chat() {
    read -r -p "Enable darker chat background? (true/false): " choice

    case $choice in
        true|false)
            update_config "APPEARANCE" "DarkChat" "$choice"
            ;;
        *)
            echo "Invalid input. Please try again."
            edit_dark_chat
            ;;
    esac
}

function edit_dark_quest_alarm() {
    read -r -p "Enable darker Quest alarm background? (true/false): " choice

    case $choice in
        true|false)
            update_config "APPEARANCE" "DarkQuestAlarm" "$choice"
            ;;
        *)
            echo "Invalid input. Please try again."
            edit_dark_quest_alarm
            ;;
    esac
}

function edit_streamer_mode() {
    read -p "Enable the Streamer Mode? (true/false): " choice

    case $choice in
        true|false)
            update_config "APPEARANCE" "StreamerMode" "$choice"
            ;;
        *)
            echo "Invalid input. Please try again."
            edit_streamer_mode
            ;;
    esac
}

function edit_weapon_effects() {
    read -p "Show visual effects for swinging a cosmetic Weapon cover? (true/false): " choice

    case $choice in
        true|false)
            update_config "APPEARANCE" "WeaponEffects" "$choice"
            ;;
        *)
            echo "Invalid input. Please try again."
            edit_weapon_effects
            ;;
    esac
}

function edit_weapons_behind_character() {
    read -p "Allow any two-handed weapon to appear behind the character's back? (true/false): " choice

    case $choice in
        true|false)
            update_config "APPEARANCE" "WeaponsBehindCharacter" "$choice"
            ;;
        *)
            echo "Invalid input. Please try again."
            edit_weapons_behind_character
            ;;
    esac
}

function edit_skip_logo_animation() {
    read -p "Skip the starting logo animations? (true/false): " choice

    case $choice in
        true|false)
            update_config "PERFORMANCE" "SkipLogoAnimation" "$choice"
            ;;
        *)
            echo "Invalid input. Please try again."
            edit_skip_logo_animation
            ;;
    esac
}

function edit_auto_clear_cache() {
    read -p "Automatic cleaning of the image cache? (true/false): " choice

    case $choice in
        true|false)
            update_config "PERFORMANCE" "AutoClearCache" "$choice"
            ;;
        *)
            echo "Invalid input. Please try again."
            edit_auto_clear_cache
            ;;
    esac
}

function edit_fast_loading() {
    read -p "Enable fast loading of game elements on game launch? (true/false): " choice

    case $choice in
        true|false)
            update_config "PERFORMANCE" "FastLoading" "$choice"
            ;;
        *)
            echo "Invalid input. Please try again."
            edit_fast_loading
            ;;
    esac
}

function edit_transition() {
    echo "Select the type of transitioning between two maps:"
    echo "1 = Classic"
    echo "2 = Modern GMS-like"
    echo "3 = Legends' Tweaks"
    read -p "Enter your choice (1/2/3): " choice

    case $choice in
        1|2|3)
            update_config "PERFORMANCE" "Transition" "$choice"
            sed -n '/\[PERFORMANCE\]/,/^\[/p' "$CONFIG_FILE" | grep "Transition"
            ;;
        *)
            echo "Invalid input. Please try again."
            edit_transition
            ;;
    esac
}

# Add more functions as needed for other settings

# Main menu for editing options
clear
while true; do
    echo "Legends Configuration Editor"
    echo "---------------------------"
    echo "Please Select an Option to Edit. Each change will automatically populate the Legends.ini file."
    echo "🔹 1. Edit HD Client"
    echo "🔹 2. Edit Windowed Mode"
    echo "🔹 3. Edit Dark Chat"
    echo "🔹 4. Edit Dark Quest Alarm"
    echo "🔹 5. Edit Streamer Mode"
    echo "🔹 6. Edit Weapon Effects"
    echo "🔹 7. Edit Weapons Behind Character"
    echo "🔹 8. Edit Skip Logo Animation"
    echo "🔹 9. Edit Auto Clear Cache"
    echo "🔹 10. Edit Fast Loading"
    echo "🔹 11. Edit Transition"
    echo "🔹 12. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1) edit_hd_client ;;
        2) edit_windowed_mode ;;
        3) edit_dark_chat ;;
        4) edit_dark_quest_alarm ;;
        5) edit_streamer_mode ;;
        6) edit_weapon_effects ;;
        7) edit_weapons_behind_character ;;
        8) edit_skip_logo_animation ;;
        9) edit_auto_clear_cache ;;
        10) edit_fast_loading ;;
        11) edit_transition ;;
        12) break ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done

echo "Configuration updated."