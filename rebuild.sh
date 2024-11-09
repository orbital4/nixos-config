#!/bin/bash

echo "💫 Starting NixOS rebuild..."

if sudo nixos-rebuild switch --flake .#acer; then
    echo "✨ NixOS rebuild completed successfully!"
else
    echo "❌ Oops! Something went wrong during the rebuild."
    exit 1
fi
