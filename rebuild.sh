#!/bin/bash

# Check if hostname argument is provided
if [ $# -eq 0 ]; then
    echo "❌ Please provide a hostname as an argument"
    echo "Usage: $0 <hostname>"
    exit 1
fi

HOSTNAME="$1"
echo "💫 Starting NixOS rebuild for $HOSTNAME..."

if sudo nixos-rebuild switch --flake ".#$HOSTNAME"; then
    echo "✨ NixOS rebuild completed successfully!"
else
    echo "❌ Oops! Something went wrong during the rebuild."
    exit 1
fi
