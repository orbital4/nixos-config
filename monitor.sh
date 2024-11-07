#!/bin/bash

# Function to get connected displays
get_displays() {
    xrandr | grep " connected" | cut -d" " -f1
}

# Function to get the primary display (usually laptop)
get_primary() {
    xrandr | grep "primary" | cut -d" " -f1
}

# Function to check if HDMI is connected
is_hdmi_connected() {
    xrandr | grep "HDMI" | grep " connected" > /dev/null
}

# Get the HDMI output name (HDMI-1, HDMI-1-0, etc.)
get_hdmi_output() {
    xrandr | grep "HDMI" | grep " connected" | cut -d" " -f1
}

# Function to show menu and get user choice
show_menu() {
    echo "Display Configuration Options:"
    echo "1) Internal Only (Laptop)"
    echo "2) External Only (HDMI)"
    echo "3) Extend Left"
    echo "q) Quit"
    echo
    read -p "Select an option: " choice
    echo
    return 0
}

# Main script
main() {
    if ! is_hdmi_connected; then
        echo "No HDMI display detected"
        exit 1
    fi

    PRIMARY=$(get_primary)
    HDMI=$(get_hdmi_output)

    show_menu

    case $choice in
        1)
            echo "Switching to laptop display only..."
            xrandr --output "$PRIMARY" --auto --primary \
                   --output "$HDMI" --off
            ;;
        2)
            echo "Switching to HDMI display only..."
            xrandr --output "$HDMI" --auto --primary \
                   --output "$PRIMARY" --off
            ;;
        3)
            echo "Extending display with HDMI on the left..."
            xrandr --output "$PRIMARY" --auto --primary \
                   --output "$HDMI" --auto --left-of "$PRIMARY"
            ;;
        q|Q)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option"
            exit 1
            ;;
    esac

    if [ $? -eq 0 ]; then
        echo "Display configuration changed successfully"
        echo "Primary display: $PRIMARY"
        echo "HDMI display: $HDMI"
    else
        echo "Failed to change display configuration"
        exit 1
    fi
}

# Run main function
main
