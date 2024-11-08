#!/bin/bash

WINDOW_ID=$(xdotool getwindowfocus)

WINDOW_PID=$(xdotool getwindowpid "$WINDOW_ID")

# Get the shell process ID (first child process)
SHELL_PID=$(pgrep -P "$WINDOW_PID" | head -n1)

if [ -n "$SHELL_PID" ]; then
    # Get working directory of the shell process
    # TODO: not great with symliked directories
    WORKING_DIR=$(readlink /proc/"$SHELL_PID"/cwd)

    if [ $? -eq 0 ] && [ -d "$WORKING_DIR" ]; then
        exec kitty --directory="$WORKING_DIR"
        exit 0
    fi
fi

exec kitty
