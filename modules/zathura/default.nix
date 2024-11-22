{ lib, config, pkgs, ... }:

{
    home.packages = with pkgs; [
        zathura
    ];

    home.file.".config/zathura/zathurarc" = {
        source = config.lib.file.mkOutOfStoreSymlink ./config/zathura-gruvbox-dark-hard;
    };
}
