{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    polybar
  ];

  home.file.".config/polybar" = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
