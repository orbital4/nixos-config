{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        bash

        # Dependencies
        zoxide
        oh-my-posh
    ];

    home.file.".bashrc" = {
        source = config.lib.file.mkOutOfStoreSymlink ./.bashrc;
    };

    home.file.".config/bash" = {
        source = config.lib.file.mkOutOfStoreSymlink ./config;
    };
}
