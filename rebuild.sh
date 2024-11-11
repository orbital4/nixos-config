#!/bin/bash

# Check if hostname argument is provided
if [ $# -eq 0 ]; then
    echo "❌ Please provide a hostname as an argument"
    echo "Usage: $0 <hostname>"
    exit 1
fi

HOSTNAME="$1"
FLAKE_HW_CONFIG="./hosts/$HOSTNAME/hardware-configuration.nix"
SYSTEM_HW_CONFIG="/etc/nixos/hardware-configuration.nix"

# Check if both hardware configuration files exist
if [ ! -f "$FLAKE_HW_CONFIG" ]; then
    echo "❌ Flake hardware configuration not found: $FLAKE_HW_CONFIG"
    exit 1
fi

if [ ! -f "$SYSTEM_HW_CONFIG" ]; then
    echo "❌ System hardware configuration not found: $SYSTEM_HW_CONFIG"
    exit 1
fi

# Compare the hardware configuration files
echo "🔍 Comparing hardware configurations..."
if ! diff -q "$FLAKE_HW_CONFIG" "$SYSTEM_HW_CONFIG" >/dev/null; then
    echo "❌ Hardware configurations do not match!"
    echo "Differences between files:"
    diff --color "$FLAKE_HW_CONFIG" "$SYSTEM_HW_CONFIG"
    exit 1
fi

echo "✅ Hardware configurations match"
echo "💫 Starting NixOS rebuild for $HOSTNAME..."

if sudo nixos-rebuild switch --flake ".#$HOSTNAME"; then
    echo "✨ NixOS rebuild completed successfully!"
else
    echo "❌ Oops! Something went wrong during the rebuild."
    exit 1
fi
