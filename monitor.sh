#!/bin/bash

get_laptop() {
    xrandr | grep "eDP" | grep " connected" | cut -d" " -f1
}

get_hdmi() {
    xrandr | grep "HDMI" | grep " connected" | cut -d" " -f1
}

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

main() {
    LAPTOP=$(get_laptop)
    HDMI=$(get_hdmi)

    show_menu

    case $choice in
        1)
            echo "Switching to laptop display only..."
            xrandr --output "$LAPTOP" --auto --primary \
                   --output "$HDMI" --off
            ;;
        2)
            echo "Switching to HDMI display only..."
            xrandr --output "$HDMI" --auto --primary \
                   --output "$LAPTOP" --off
            ;;
        3)
            echo "Extending display with HDMI on the left..."
            xrandr --output "$LAPTOP" --auto --primary \
                   --output "$HDMI" --auto --left-of "$LAPTOP"
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
        echo "Primary display: $LAPTOP"
        echo "HDMI display: $HDMI"
    else
        echo "Failed to change display configuration"
        exit 1
    fi
}

main
