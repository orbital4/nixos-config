{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        i3

        # Dependencies
        i3status
        i3lock
        dmenu
        kitty
        dunst
        polybar
        hsetroot
    ];

    xsession = {
        enable = true;
        windowManager.command = "i3";
    };

    home.file.".config/i3" = {
      source = config.lib.file.mkOutOfStoreSymlink ./config;
    };
}
