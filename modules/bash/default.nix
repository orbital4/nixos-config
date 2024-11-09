{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        bash

        # Dependencies
        zoxide
        lf
    ];

    home.file.".bashrc" = {
        source = config.lib.file.mkOutOfStoreSymlink ./.bashrc;
    };
}
