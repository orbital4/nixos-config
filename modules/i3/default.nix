{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        i3
        i3status
        i3lock
        dmenu
        kitty
    ];

    xsession = {
        enable = true;
        windowManager.command = "i3";
    };

    home.file.".config/i3" = {
      source = config.lib.file.mkOutOfStoreSymlink ./config;
    };
}
