{ config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "nixos";
    networking.networkmanager.enable = true;

    time.timeZone = "America/Sao_Paulo";

    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "pt_BR.UTF-8";
        LC_IDENTIFICATION = "pt_BR.UTF-8";
        LC_MEASUREMENT = "pt_BR.UTF-8";
        LC_MONETARY = "pt_BR.UTF-8";
        LC_NAME = "pt_BR.UTF-8";
        LC_NUMERIC = "pt_BR.UTF-8";
        LC_PAPER = "pt_BR.UTF-8";
        LC_TELEPHONE = "pt_BR.UTF-8";
        LC_TIME = "pt_BR.UTF-8";
    };

    services.xserver.xkb = {
        layout = "us";
        variant = "";
    };

    # Enable sound with pipewire.
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

    # Enable bluetooth
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable = true;

    users.users.al = {
        isNormalUser = true;
        description = "al";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs; [];
    };

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
        firefox # browser
        gcc # c make
        xsel # clipboard
        xclip #clipboard
        file # Shows the type of files
        ripgrep # fuzzy finder
        fzf # fuzzy finder
        busybox # UNIX utilities
        bat # better cat
        brightnessctl # change brightness
    ];

    services.xserver = {
        enable = true;

        windowManager.i3 = {
            enable = true;
        };

        displayManager = {
            lightdm.enable = true;
        };
    };

    services.displayManager.defaultSession = "none+i3";

    environment.variables = {
        SUDO_EDITOR = "nvim";
        VISUAL = "nvim";
        EDITOR = "nvim";
    };

    environment.shellAliases = {
        v = "nvim";
    };

    system.stateVersion = "24.05";
}
