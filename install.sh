#!/bin/bash

# Welcome function
function display_welcome_message() {
    cat <<"EOF"
   ______      _______           __ 
  / ____/_  __/ / __(_)_________/ /_
 / / __/ / / / / /_/ / ___/ ___/ __/
/ /_/ / /_/ / / __/ / /  (__  ) /_  
\____/\__, /_/_/ /_/_/  /____/\__/  
    /____/                         
EOF
    echo "This script will help you setup my dotfiles."
}

# Exit function
function display_exit_message() {
    echo "The script is ended."
    echo "Enjoy your configuration of your Arch Linux"
    echo "Remember that we use Arch BTW..."
}

# Just draw a line
function draw_line() {
    echo -e "\n-----------------------------------------------------------\n"
}

# List of the software that is required for the dotfiles to work
software_list=("wget tar fastfetch hyprland hyprlock hypridle hyprpaper hyprshot kitty waybar wlogout wofi brave python-pywal rofi swaync python cliphist")

# Function that installs the softwares (Arch only)
function install_software() {
    sudo pacman -Sy --noconfirm "${software_list[@]}"
    # needed for dynamic change of wallpaper
    read -p "Which helper do you have installed? [paru/yay]: " arch_helper
    if [ "$arch_helper" == "paru" ]; then
        paru -Sy --noconfirm hyprpaper
    elif [ "$arch_helper"  == "yay" ]; then
        yay -Sy --noconfirm hyprpaper
    else
        echo "Helper unsupported, open an issue on the Git repo."
    fi
}

# List of font that I use
font_list=("ttf-jetbrains-mono-nerd")

# Function that installs the fonts that I use on my system
function install_fonts() {
    sudo pacman -Sy --noconfirm "${font_list[@]}"
}

# Install all the requirements
function install_requirements() {
    install_software
    install_fonts
}

# Copy the dotfiles into the .config directory
function install_dotfiles() {
    # Create the directory if it is not existant
    mkdir -p $HOME/.config
    cp -r home/.config/ $HOME/.config
}

# Install and copy the config
function install_ohMyZsh() {
    # Install Oh My Z Shell
    bash -c "$(curl -fsSL https://install.ohmyz.sh/)"
    # Create the directory for my custom theme
    mkdir -p $HOME/.oh-my-zsh/custom/themes
    # Copy the theme and the config
    cp home/.oh-my-zsh/gylfirst.zsh-theme $HOME/.oh-my-zsh/custom/themes/gylfirst.zsh-theme
    cp home/.zshrc $HOME/.zshrc
}

function install_speedtest() {
    wget -O /tmp/speedtest.tgz "https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-x86_64.tgz"
    mkdir -p /tmp/speedtest
    tar -xzvf /tmp/speedtest.tgz -C /tmp/speedtest
    sudo cp /tmp/speedtest/speedtest /usr/bin/
    rm -rf /tmp/speedtest /tmp/speedtest.tgz
}

# Main function of the script
function main() {
    clear
    display_welcome_message
    draw_line
    
    # Check if the user is root
    if [  "$EUID" -ne 0 ]; then
        echo -e "Asking for root password to install the requirements..."
        sudo bash -c "$(declare -f install_requirements); install_requirements"
    else
        install_requirements
    fi
    
    draw_line
    install_dotfiles
    draw_line
    install_ohMyZsh
    draw_line

    read -p "Do you want to install speedtest (from speedtest.net)? [Y/n]: " ask_speedtest
    : "${ask_speedtest:="y"}"
    if [ "$ask_speedtest" = "y" ] || [ "$ask_speedtest" = "Y" ]; then
        # Check if the user is root
        if [  "$EUID" -ne 0 ]; then
            echo -e "Asking for root password to install speedtest..."
            sudo bash -c "$(declare -f install_speedtest); install_speedtest"
        else
            install_speedtest
        fi
    else
        echo "Skipping speedtest setup..."
    fi

    draw_line
    display_exit_message
}

# Execute the script
main
