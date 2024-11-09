{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        polybar

        # Dependencies
        (nerdfonts.override { fonts = [ "IBMPlexMono" ]; })
    ];

    home.file.".config/polybar" = {
        source = config.lib.file.mkOutOfStoreSymlink ./config;
    };
}
