{ config, lib, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "z4mbo" ];
    };
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 3;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

    kernelPackages = pkgs.linuxPackages_latest;

    # Better kernel parameters for gaming
    kernelParams = [
      "nvidia_drm.modeset=1"
      "nvidia_drm.fbdev=1"
    ];
  };

  # Swap file for gaming (prevents OOM with large games)
  swapDevices = [{
    device = "/swapfile";
    size = 16 * 1024; # 16GB
  }];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  programs.niri.enable = true;
  services.displayManager.ly.enable = true;

  # Steam with proper gaming support
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  # GameMode for optimized gaming performance
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
      };
    };
  };

  # Gamescope compositor for better game compatibility
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_RENDERER = "vulkan";
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.xkb.layout = "it";
  console.keyMap = "it2";

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  virtualisation.docker.enable = true;

  users.users.z4mbo = {
    isNormalUser = true;
    description = "Alessandro Zambon";
    extraGroups = [ "networkmanager" "wheel" "video" "docker" ];
    shell = pkgs.zsh;
  };

  users.users.root.shell = pkgs.zsh;

  programs.zsh = {
    enable = true;

    shellAliases = {
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
    };

    interactiveShellInit = ''
      # Ensure NIX_PATH is set correctly
      export NIX_PATH="nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos:nixos-config=/etc/nixos/configuration.nix:/nix/var/nix/profiles/per-user/root/channels"

      if [[ $EUID -eq 0 ]]; then
        POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir user)
        POWERLEVEL9K_OS_ICON_BACKGROUND="red"
        POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
        POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
      else
        POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon vcs user prompt_char)
        POWERLEVEL9K_OS_ICON_BACKGROUND="none"
        POWERLEVEL9K_VCS_BACKGROUND='#FFA500'
        POWERLEVEL9K_VCS_FOREGROUND='#000000'
        POWERLEVEL9K_USER_BACKGROUND='#000000'
        POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='~'
        POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='~'
        POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='white'
        POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='white'
        POWERLEVEL9K_PROMPT_CHAR_BACKGROUND='none'
        POWERLEVEL9K_USER_RIGHT_PADDING=1
      fi

      POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
      POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
      POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=""
      POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=""
      POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs)
      POWERLEVEL9K_MODE="nerdfont-v3"

      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
    '';

    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
    };
  };

  environment.systemPackages = with pkgs; [
    # Editors
    vim
    neovim

    # Core tools
    git
    tmux
    btop
    efibootmgr

    # Wayland/NVIDIA
    egl-wayland
    nvidia-vaapi-driver
    xwayland-satellite
    wl-clipboard
    grim
    slurp
    swaybg
    pwvucontrol

    # Gaming tools
    vulkan-tools
    vulkan-loader

    # Networking
    networkmanagerapplet

    # AI tools
    gemini-cli
    opencode
    claude-code

    # Fun
    neofetch
    antigravity
    genact
    cmatrix
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = [ "gnome" "gtk" ];
  };

  security.sudo.extraRules = [
    {
      users = [ "z4mbo" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  security.sudo.extraConfig = ''
    Defaults env_keep += "NIX_PATH"
  '';

  home-manager.users.z4mbo = import ./home.nix;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";

  system.stateVersion = "25.11";
}
