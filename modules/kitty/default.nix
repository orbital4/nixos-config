{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        kitty

        # Dependencies
        ibm-plex
    ];

    home.file.".config/kitty" = {
        source = config.lib.file.mkOutOfStoreSymlink ./config;
    };
}


