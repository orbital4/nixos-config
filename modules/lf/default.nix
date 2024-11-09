{ lib, config, pkgs, ... }:

{
    home.packages = with pkgs; [
        lf
    ];

    home.file.".config/lf" = {
        source = config.lib.file.mkOutOfStoreSymlink ./config;
    };
}
