{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        bash

        # Dependencies
        zoxide
    ];

    home.file.".bashrc" = {
        source = config.lib.file.mkOutOfStoreSymlink ./.bashrc;
    };
}
