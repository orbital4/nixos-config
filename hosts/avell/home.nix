{ config, pkgs, ... }:

{
    imports = [
        ../../modules/nvim
        ../../modules/i3
        # ../../modules/polybar
        ../../modules/kitty
        ../../modules/bash
        ../../modules/lf
        ../../modules/qutebrowser
        ../../modules/zathura
    ];

    home.username = "al";
    home.homeDirectory = "/home/al";
    home.stateVersion = "24.05";

    home.packages = with pkgs; [
        fastfetch
        proton-pass
        obsidian
        blueman
        bitwarden-cli
    ];

    programs.home-manager.enable = true;

    programs.git = {
        enable = true;
        userName  = "orbital4";
        userEmail = "github.b5jge@passmail.net";
        extraConfig = {
            init = {
                defaultBranch = "main";
            };
        };
    };
}
