{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nixpkgs.config.allowUnfree = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  virtualisation.docker.enable = true;

  programs.niri.enable = true;
  services.displayManager.ly.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_RENDERER = "vulkan";
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.xkb = {
    layout = "it";
  };
  console.keyMap = "it2";

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.z4mbo = {
    isNormalUser = true;
    description = "Alessandro Zambon";
    extraGroups = [ "networkmanager" "wheel" "video" "docker" ];
    packages = with pkgs; [
      godot
      blender
      # User apps from home.nix
      zsh-powerlevel10k
      ghostty
      fuzzel
      wlogout
      google-chrome
      btop
    ];
  };

  users.users.root = {
    shell = pkgs.zsh;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Set zsh as default shell with full config
  programs.zsh.enable = true;
  users.users.z4mbo.shell = pkgs.zsh;

  # Zsh configuration (moved from home.nix)
  programs.zsh.interactiveShellInit = ''
    # Powerlevel10k
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    POWERLEVEL9K_MODE="nerdfont-v3"
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs user)
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs)
    POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
    POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
    POWERLEVEL9K_OS_ICON_BACKGROUND="black"
    source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

    # Aliases
    alias ll="ls -alF"
    alias la="ls -A"
    alias l="ls -CF"
    neofetch
  '';

  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" ];
  };

  # Oh-my-zsh theme
  programs.zsh.ohMyZsh.theme = "agnoster";

  environment.systemPackages = with pkgs; [
    vim #:q
    git #version control
    egl-wayland #idk
    nvidia-vaapi-driver #nvidia stuff
    xwayland-satellite #require for launching apps in Niri window manager
    neovim #ide (NvChad)
    ghostty #terminal
    google-chrome #browser
    fuzzel #app launcher
    wl-clipboard #clipboard manager
    btop #performance monitor
    pwvucontrol #pipewire volume control
    swaybg #background service
    opencode
    tmux #terminal multiplexer
    efibootmgr #EFI boot manager
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = [ "gnome" "gtk" ];
  };

  system.stateVersion = "25.11";

  # Configure zsh and Powerlevel10k for root
  system.activationScripts.rootZshSetup = ''
    mkdir -p /root
    cat > /root/.zshrc << 'EOF'
# Powerlevel10k configuration for root
POWERLEVEL9K_MODE="nerdfont-v3"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir user)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs)
POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
POWERLEVEL9K_OS_ICON_BACKGROUND="red"
source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

# Aliases
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
EOF
  '';

  # Make z4mbo a super user with passwordless sudo
  security.sudo.extraRules = [
    {
      users = [ "z4mbo" ];
      commands = [
        { command = "ALL"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];
}