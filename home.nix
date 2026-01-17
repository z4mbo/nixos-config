{ config, pkgs, ... }:

{
  home.username = "z4mbo";
  home.homeDirectory = "/home/z4mbo";
  home.stateVersion = "25.11";

  # Removed systemd services for waybar and swaync
  # They are now started via niri's spawn-at-startup for better timing

  programs.waybar = {
    enable = true;
    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: "JetBrainsMono Nerd Font";
          font-size: 16px;
          min-height: 0;
          margin: 0;
          padding: 0;
      }

      window#waybar {
          background: #000000;
          color: #ffffff;
          padding-left: 8px;
          padding-right: 8px;
      }

      #workspaces {
          background: transparent;
      }

      #workspaces button {
          padding: 0 12px;
          color: #ffffff;
          background: transparent;
          transition: all 0.2s ease-in-out;
      }

      #workspaces button:first-child {
          padding-left: 0;
      }

      #workspaces button.active {
          color: #5277C3;
          background: transparent;
          font-weight: bold;
      }

      #workspaces button.focused {
          color: #5277C3;
          background: transparent;
          font-weight: bold;
      }

      #window,
      #clock,
      #cpu,
      #memory,
      #disk,
      #custom-gpu,
      #custom-power,
      #custom-notification,
      #pulseaudio {
          padding: 0 12px;
          background: transparent;
          color: #ffffff;
      }

      #tray {
          padding: 0 12px;
          background: transparent;
      }

      #tray > .passive {
          -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          color: #5277C3;
      }

      #pulseaudio.muted {
          color: #666666;
      }

      #custom-notification {
          padding: 0 8px;
      }

      #custom-power {
          padding-left: 12px;
          padding-right: 8px;
      }


      tooltip {
          background: #1a1a1a;
          border: 1px solid #333333;
          border-radius: 4px;
      }

      tooltip label {
          color: #ffffff;
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 40;
        modules-left = [ "niri/workspaces" "niri/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "cpu" "custom/gpu" "memory" "disk" "pulseaudio" "custom/notification" "custom/power" ];

        "niri/workspaces" = {
          format = "{icon}";
          "all-outputs" = true;
          "format-icons" = {
            "1" = "󰚩 Ai";
            "2" = " Terminal";
            "3" = "󰖟 Browser";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "";
          };
        };

        "niri/window" = {
            "format" = "- {title}";
            "separate-outputs" = true;
            "max-length" = 50;
        };

        "clock" = {
          "format" = "{:%A %e %B %Y - %H:%M}";
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          "on-click" = "google-chrome-stable --app=https://calendar.google.com";
        };

        "cpu" = {
          "format" = "CPU {usage}%";
          "tooltip" = true;
        };

        "custom/gpu" = {
          "exec" = "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits";
          "format" = "GPU {}%";
          "interval" = 5;
          "tooltip" = true;
        };

        "memory" = {
          "format" = "RAM {}%";
        };

        "disk" = {
          "format" = "SSD {percentage_used}%";
          "path" = "/";
        };

        "tray" = {
          "icon-size" = 18;
          "spacing" = 8;
        };

        "pulseaudio" = {
          "format" = "{icon} {volume}%";
          "format-muted" = "󰝟 Muted";
          "format-icons" = {
            "default" = [ "󰕿" "󰖀" "󰕾" ];
          };
          "on-click" = "pwvucontrol";
          "on-click-right" = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "on-scroll-up" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "on-scroll-down" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "tooltip" = true;
          "tooltip-format" = "{desc} - {volume}%";
        };

        "custom/notification" = {
          "tooltip" = false;
          "format" = "{icon}";
          "format-icons" = {
            "notification" = "󰂚";
            "none" = "󰂜";
            "dnd-notification" = "󰂛";
            "dnd-none" = "󰪑";
            "inhibited-notification" = "󰂚";
            "inhibited-none" = "󰂜";
            "dnd-inhibited-notification" = "󰂛";
            "dnd-inhibited-none" = "󰪑";
          };
          "return-type" = "json";
          "exec" = "swaync-client -swb";
          "on-click" = "swaync-client -t -sw";
          "on-click-right" = "swaync-client -d -sw";
          "escape" = true;
        };

        "custom/power" = {
          "format" = "";
          "on-click" = "${config.home.homeDirectory}/.local/bin/powermenu.sh";
          "tooltip" = "Power Menu";
        };
      };
    };
  };

  # tmux theme
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g status-bg "#5277C3"
      set -g status-fg "#000000"
      set -g pane-active-border-style fg='#5277C3'
      set -g pane-border-style fg='#333333'
      set -g message-style bg='#5277C3',fg='#000000'
      set -g status-position bottom
    '';
  };

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Git
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Alessandro Zambon";
        email = "alessandrozambon1997@gmail.com";
      };
      safe.directory = "/etc/nixos";
    };
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings = {
      git_protocol = "https";
    };
  };

  # Zsh with Powerlevel10k
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    initContent = ''
      if [ -z "$TMUX" ]; then
        exec tmux
      fi
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };

    shellAliases = {
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
    };
  };

  # Niri configuration
  home.file.".config/niri/config.kdl".text = ''
    output "DP-1" {
        mode "2560x1440@359.999"
    }

    input {
        keyboard {
            xkb {
                layout "it"
            }
        }

        touchpad {
            tap
            natural-scroll
        }
    }

    workspace "1"
    workspace "2"
    workspace "3"
    workspace "4"
    workspace "5"
    workspace "6"
    workspace "7"
    workspace "8"
    workspace "9"

    window-rule {
        geometry-corner-radius 8
        clip-to-geometry true
    }

    layout {
        gaps 8
        center-focused-column "never"


        preset-column-widths {
            proportion 0.25
            proportion 0.33333
            proportion 0.5
            proportion 0.75
            proportion 1.0
        }

        preset-window-heights {
            proportion 0.25
            proportion 0.33333
            proportion 0.5
            proportion 0.75
            proportion 1.0
        }

        default-column-width { proportion 0.5; }

        border {
            width 1
            active-color "#5277C3"
            inactive-color "#333333"
        }

        focus-ring {
            off
        }
    }

    prefer-no-csd

    spawn-at-startup "swaybg" "-c" "#000000"
    spawn-at-startup "waybar"
    spawn-at-startup "swaync"

    binds {
        Mod+Return { spawn "ghostty"; }
        Mod+Space { spawn "rofi" "-show" "drun" "-show-icons"; }
        Mod+E { spawn "nautilus"; }
        Mod+Q { close-window; }
        Mod+W { toggle-window-floating; }

        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }
        Mod+Right { focus-column-right; }
        Mod+H     { focus-column-left; }
        Mod+J     { focus-window-down; }
        Mod+K     { focus-window-up; }
        Mod+L     { focus-column-right; }

        Mod+Shift+Left  { move-column-left; }
        Mod+Shift+Down  { move-window-down; }
        Mod+Shift+Up    { move-window-up; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+H     { move-column-left; }
        Mod+Shift+J     { move-window-down; }
        Mod+Shift+K     { move-window-up; }
        Mod+Shift+L     { move-column-right; }

        Mod+Comma  { consume-window-into-column; }
        Mod+Period { expel-window-from-column; }

        Mod+R { switch-preset-column-width; }
        Mod+Shift+R { switch-preset-window-height; }

        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }

        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }

        Mod+1 { focus-workspace "1"; }
        Mod+2 { focus-workspace "2"; }
        Mod+3 { focus-workspace "3"; }
        Mod+4 { focus-workspace "4"; }
        Mod+5 { focus-workspace "5"; }
        Mod+6 { focus-workspace "6"; }
        Mod+7 { focus-workspace "7"; }
        Mod+8 { focus-workspace "8"; }
        Mod+9 { focus-workspace "9"; }

        Mod+Shift+1 { move-column-to-workspace "1"; }
        Mod+Shift+2 { move-column-to-workspace "2"; }
        Mod+Shift+3 { move-column-to-workspace "3"; }
        Mod+Shift+4 { move-column-to-workspace "4"; }
        Mod+Shift+5 { move-column-to-workspace "5"; }
        Mod+Shift+6 { move-column-to-workspace "6"; }
        Mod+Shift+7 { move-column-to-workspace "7"; }
        Mod+Shift+8 { move-column-to-workspace "8"; }
        Mod+Shift+9 { move-column-to-workspace "9"; }

        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }

        Mod+Shift+E { quit; }

        Mod+Slash { show-hotkey-overlay; }
    }

    cursor {
        xcursor-theme "Adwaita"
        xcursor-size 24
    }

    screenshot-path "~/Pictures/Screenshots/screenshot-%Y-%m-%d-%H-%M-%S.png"
  '';

  home.file.".config/rofi/config.rasi".text = ''
    @theme "/dev/null"

    configuration {
        modi: "drun,run";
        show-icons: true;
        icon-theme: "Adwaita";
        font: "JetBrainsMono Nerd Font 16";
        drun-display-format: "{name}";
        drun-match-fields: "name,generic,keywords";
    }

    * {
        bg: #000000;
        bg-alt: #1a1a1a;
        fg: #ffffff;
        accent: #5277C3;
    }

    window {
        width: 600px;
        background-color: @bg;
        border: 2px;
        border-color: @accent;
                  border-radius: 8px;
        padding: 20px;
    }

    mainbox {
        background-color: @bg;
        spacing: 10px;
    }

    inputbar {
        background-color: @bg-alt;
        border-radius: 8px;
        padding: 12px;
        children: [prompt, entry];
    }

    prompt {
        background-color: @bg-alt;
        text-color: @accent;
        padding: 0 10px 0 0;
    }

    entry {
        background-color: @bg-alt;
        text-color: @fg;
        placeholder: "Search...";
        placeholder-color: #666666;
    }

    listview {
        background-color: @bg;
        lines: 8;
        spacing: 5px;
        fixed-height: false;
    }

    element {
        background-color: @bg;
        padding: 10px;
        border-radius: 8px;
    }

    element selected {
        background-color: @accent;
    }

    element-icon {
        size: 24px;
        margin: 0 10px 0 0;
        background-color: inherit;
    }

    element-text {
        text-color: @fg;
        vertical-align: 0.5;
        background-color: inherit;
    }

    element selected element-text {
        text-color: @bg;
    }
  '';

  home.file.".config/ghostty/config".text = ''
    font-family = JetBrainsMono Nerd Font
    font-size = 16
    background = 000000
    foreground = ffffff
    selection-background = 5277C3
    selection-foreground = 000000
    cursor-color = 5277C3
    window-padding-x = 15
    window-padding-y = 15
    mouse-scroll-multiplier = 3
    shell-integration = none
  '';

  # Hide unwanted apps from rofi
  home.file.".local/share/applications/btop.desktop".text = ''
    [Desktop Entry]
    Name=btop++
    Type=Application
    NoDisplay=true
  '';
  home.file.".local/share/applications/nm-connection-editor.desktop".text = ''
    [Desktop Entry]
    Name=Advanced Network Configuration
    Type=Application
    NoDisplay=true
  '';
  home.file.".local/share/applications/nvidia-settings.desktop".text = ''
    [Desktop Entry]
    Name=NVIDIA X Server Settings
    Type=Application
    NoDisplay=true
  '';
  home.file.".local/share/applications/vim.desktop".text = ''
    [Desktop Entry]
    Name=Vim
    Type=Application
    NoDisplay=true
  '';
  home.file.".local/share/applications/gvim.desktop".text = ''
    [Desktop Entry]
    Name=GVim
    Type=Application
    NoDisplay=true
  '';
  home.file.".local/share/applications/rofi.desktop".text = ''
    [Desktop Entry]
    Name=Rofi
    Type=Application
    NoDisplay=true
  '';
  home.file.".local/share/applications/rofi-theme-selector.desktop".text = ''
    [Desktop Entry]
    Name=Rofi Theme Selector
    Type=Application
    NoDisplay=true
  '';
  home.file.".local/share/applications/nvim.desktop".text = ''
    [Desktop Entry]
    Name=Neovim
    GenericName=Text Editor
    Comment=Edit text files
    Exec=nvim %F
    Terminal=true
    Type=Application
    Keywords=Text;editor;
    Icon=nvim
    Categories=Utility;TextEditor;
    StartupNotify=false
    MimeType=text/english;text/plain;
  '';

  # Web Apps (Omarchy-style)
  home.file.".local/share/applications/chatgpt.desktop".text = ''
    [Desktop Entry]
    Name=ChatGPT
    Comment=OpenAI ChatGPT
    Exec=google-chrome-stable --app=https://chat.openai.com
    Icon=${config.home.homeDirectory}/.local/share/icons/webapps/chatgpt.png
    Type=Application
    Categories=Network;WebBrowser;
  '';
  home.file.".local/share/applications/claude.desktop".text = ''
    [Desktop Entry]
    Name=Claude
    Comment=Anthropic Claude AI
    Exec=google-chrome-stable --app=https://claude.ai
    Icon=${config.home.homeDirectory}/.local/share/icons/webapps/claude-ai.png
    Type=Application
    Categories=Network;WebBrowser;
  '';
  home.file.".local/share/applications/gemini.desktop".text = ''
    [Desktop Entry]
    Name=Gemini
    Comment=Google Gemini AI
    Exec=google-chrome-stable --app=https://gemini.google.com
    Icon=${config.home.homeDirectory}/.local/share/icons/webapps/google-gemini.png
    Type=Application
    Categories=Network;WebBrowser;
  '';
  home.file.".local/share/applications/grok.desktop".text = ''
    [Desktop Entry]
    Name=Grok
    Comment=xAI Grok
    Exec=google-chrome-stable --app=https://grok.com
    Icon=${config.home.homeDirectory}/.local/share/icons/webapps/grok.png
    Type=Application
    Categories=Network;WebBrowser;
  '';
  home.file.".local/share/applications/google-calendar.desktop".text = ''
    [Desktop Entry]
    Name=Google Calendar
    Comment=Google Calendar
    Exec=google-chrome-stable --app=https://calendar.google.com
    Icon=${config.home.homeDirectory}/.local/share/icons/webapps/google-calendar.png
    Type=Application
    Categories=Office;Calendar;
  '';
  home.file.".local/share/applications/figma.desktop".text = ''
    [Desktop Entry]
    Name=Figma
    Comment=Figma Design Tool
    Exec=google-chrome-stable --app=https://www.figma.com
    Icon=${config.home.homeDirectory}/.local/share/icons/webapps/figma.png
    Type=Application
    Categories=Graphics;Design;
  '';

  # Download webapp icons on activation
  home.activation.downloadWebappIcons = config.lib.dag.entryAfter ["writeBoundary"] ''
    PATH="${pkgs.coreutils}/bin:${pkgs.curl}/bin:$PATH"
    ICON_DIR="$HOME/.local/share/icons/webapps"
    run mkdir -p "$ICON_DIR"

    download_icon() {
      if [ ! -f "$ICON_DIR/$2" ]; then
        run curl -sL "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/$1.png" -o "$ICON_DIR/$2"
      fi
    }

    download_icon "chatgpt" "chatgpt.png"
    download_icon "claude-ai" "claude-ai.png"
    download_icon "google-gemini" "google-gemini.png"
    download_icon "grok" "grok.png"
    download_icon "google-calendar" "google-calendar.png"
    download_icon "figma" "figma.png"
  '';

  home.file.".local/bin/powermenu.sh" = {
    text = ''
      #!/bin/sh
      entries="Logout\nReboot\nShutdown"
      selected=$(echo -e $entries | rofi -dmenu -p "Power Menu" -theme-str 'window {width: 300px;} listview {lines: 3;}')
      case $selected in
        Logout) niri msg action quit;;
        Reboot) reboot;;
        Shutdown) shutdown now;;
      esac
    '';
    executable = true;
  };

  home.file.".local/bin/cheatsheet.sh" = {
    text = ''
      #!/bin/sh
      if pgrep -f "ghostty.*class=cheatsheet" > /dev/null; then
        pkill -f "ghostty.*class=cheatsheet"
      else
        ghostty --class=cheatsheet -e sh -c 'cat ~/.local/share/niri-cheatsheet.txt; read -r'
      fi
    '';
    executable = true;
  };

  home.file.".local/share/niri-cheatsheet.txt".text = ''
    ╔══════════════════════════════════════════════════════════════╗
    ║                    NIRI CHEATSHEET                           ║
    ╠══════════════════════════════════════════════════════════════╣
    ║  WINDOWS                                                     ║
    ║    Super + Return      Open terminal                         ║
    ║    Super + Space       App launcher (rofi)                   ║
    ║    Super + E           File manager                          ║
    ║    Super + Q           Close window                          ║
    ║    Super + F           Full width (maximize column)           ║
    ║    Super + Shift + F   Fullscreen                            ║
    ╠══════════════════════════════════════════════════════════════╣
    ║  NAVIGATION                                                  ║
    ║    Super + H/Left      Focus left                            ║
    ║    Super + J/Down      Focus down                            ║
    ║    Super + K/Up        Focus up                              ║
    ║    Super + L/Right     Focus right                           ║
    ╠══════════════════════════════════════════════════════════════╣
    ║  MOVE WINDOWS                                                ║
    ║    Super + Shift + H/Left   Move left                        ║
    ║    Super + Shift + J/Down   Move down                        ║
    ║    Super + Shift + K/Up     Move up                          ║
    ║    Super + Shift + L/Right  Move right                       ║
    ╠══════════════════════════════════════════════════════════════╣
    ║  RESIZE                                                      ║
    ║    Super + R           Cycle width (25→33→50→75→100%)        ║
    ║    Super + Shift + R   Cycle height (25→33→50→75→100%)       ║
    ║    Super + -/=         Shrink/grow width 10%                 ║
    ║    Super + Shift + -/= Shrink/grow height 10%                ║
    ╠══════════════════════════════════════════════════════════════╣
    ║  COLUMNS                                                     ║
    ║    Super + ,           Consume window into column            ║
    ║    Super + .           Expel window from column              ║
    ╠══════════════════════════════════════════════════════════════╣
    ║  WORKSPACES                                                  ║
    ║    Super + 1-9         Switch to workspace                   ║
    ║    Super + Shift + 1-9 Move window to workspace              ║
    ╠══════════════════════════════════════════════════════════════╣
    ║  SYSTEM                                                      ║
    ║    Super + \           Toggle this cheatsheet                ║
    ║    Super + /           Hotkey overlay                        ║
    ║    Super + Shift + E   Quit niri                             ║
    ╚══════════════════════════════════════════════════════════════╝
  '';


  # GTK dark theme
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
    };
    iconTheme = {
      name = "Adwaita";
    };
    gtk3.extraCss = ''
      @define-color accent_color #5277C3;
      @define-color accent_bg_color #5277C3;
      @define-color window_bg_color #000000;
      @define-color view_bg_color #000000;
      @define-color headerbar_bg_color #000000;
      @define-color sidebar_bg_color #000000;
      @define-color card_bg_color #0a0a0a;
      window, .background { background-color: #000000; }
    '';
    gtk4.extraCss = ''
      @define-color accent_color #5277C3;
      @define-color accent_bg_color #5277C3;
      @define-color window_bg_color #000000;
      @define-color view_bg_color #000000;
      @define-color headerbar_bg_color #000000;
      @define-color sidebar_bg_color #000000;
      @define-color card_bg_color #0a0a0a;
      @define-color popover_bg_color #000000;
      @define-color dialog_bg_color #000000;
      window, .background, .view { background-color: #000000; }
      headerbar { background-color: #000000; }
      .sidebar, .navigation-sidebar { background-color: #000000; }
    '';
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
    };
  };

  # Opencode config
  home.file.".opencode.json".text = ''
    {
      "theme": "tokyonight"
    }
  '';

  # Spicetify theme matching system colors
  home.file.".config/spicetify/Themes/CustomDark/color.ini".text = ''
    [custom]
    text               = ffffff
    subtext            = cccccc
    sidebar-text       = ffffff
    main               = 000000
    sidebar            = 000000
    player             = 000000
    card               = 1a1a1a
    shadow             = 000000
    selected-row       = 5277C3
    button             = 5277C3
    button-active      = 5277C3
    button-disabled    = 333333
    tab-active         = 5277C3
    notification       = 5277C3
    notification-error = ff4444
    misc               = 333333
  '';

  home.file.".config/spicetify/Themes/CustomDark/user.css".text = ''
    :root {
      --spice-text: #ffffff;
      --spice-subtext: #cccccc;
      --spice-main: #000000;
      --spice-sidebar: #000000;
      --spice-player: #000000;
      --spice-card: #1a1a1a;
      --spice-button: #5277C3;
      --spice-button-active: #5277C3;
      --spice-notification: #5277C3;
    }
  '';

  # Swaync configuration
  home.file.".config/swaync/config.json".text = builtins.toJSON {
    "$schema" = "/etc/xdg/swaync/configSchema.json";
    positionX = "right";
    positionY = "top";
    layer = "overlay";
    control-center-layer = "top";
    layer-shell = true;
    cssPriority = "user";
    control-center-margin-top = 46;
    control-center-margin-bottom = 10;
    control-center-margin-right = 10;
    control-center-margin-left = 0;
    notification-2fa-action = true;
    notification-inline-replies = false;
    notification-icon-size = 48;
    notification-body-image-height = 100;
    notification-body-image-width = 200;
    timeout = 5;
    timeout-low = 3;
    timeout-critical = 0;
    fit-to-screen = false;
    control-center-width = 400;
    control-center-height = 600;
    notification-window-width = 400;
    keyboard-shortcuts = true;
    image-visibility = "when-available";
    transition-time = 200;
    hide-on-clear = false;
    hide-on-action = true;
    script-fail-notify = true;
    scripts = {};
    notification-visibility = {};
    widgets = [
      "title"
      "dnd"
      "notifications"
    ];
    widget-config = {
      title = {
        text = "Notifications";
        clear-all-button = true;
        button-text = "Clear All";
      };
      dnd = {
        text = "Do Not Disturb";
      };
    };
  };

  home.file.".config/swaync/style.css".text = ''
    * {
      font-family: "JetBrainsMono Nerd Font";
      font-size: 16px;
      color: #ffffff;
    }

    window,
    window.blank-window,
    window.notification-window,
    window.control-center {
      background: transparent;
    }

    box.notifications {
      background: transparent;
    }

    .notification-row {
      outline: none;
      background: transparent;
    }

    .notification-row:focus,
    .notification-row:hover {
      background: transparent;
    }

    .notification-row .notification-background {
      background: transparent;
    }

    .notification-row .notification-background .notification {
      background: #000000;
                border-radius: 8px;
      margin: 6px 12px;
      box-shadow: none;
      padding: 0;
      border: 2px solid #5277C3;
    }

    .notification-content {
      background: #000000;
      padding: 10px;
      border-radius: 8px;
    }

    .close-button {
      background: #5277C3;
      color: #000000;
      text-shadow: none;
      padding: 0;
      border-radius: 100%;
      margin-top: 10px;
      margin-right: 10px;
      box-shadow: none;
      border: none;
      min-width: 24px;
      min-height: 24px;
    }

    .close-button:hover {
      box-shadow: none;
      background: #6b8fd4;
    }

    .notification-default-action,
    .notification-action {
      padding: 4px;
      margin: 0;
      box-shadow: none;
      background: #000000;
      border: none;
      color: #ffffff;
      transition: all 200ms ease;
      border-radius: 8px;
    }

    .notification-default-action:hover,
    .notification-action:hover {
      background: #5277C3;
      color: #000000;
    }

    .notification-default-action {
      border-radius: 8px;
      background: #000000;
    }

    .notification-default-action:not(:only-child) {
      border-bottom-left-radius: 0px;
      border-bottom-right-radius: 0px;
    }

    .notification-action:first-child {
      border-bottom-left-radius: 10px;
    }

    .notification-action:last-child {
      border-bottom-right-radius: 10px;
    }

    .inline-reply {
      margin-top: 8px;
    }

    .inline-reply-entry {
      background: #000000;
      color: #ffffff;
      caret-color: #ffffff;
      border: 1px solid #5277C3;
      border-radius: 8px;
    }

    .inline-reply-button {
      margin-left: 4px;
      background: #5277C3;
      border: none;
      border-radius: 8px;
      color: #000000;
    }

    .inline-reply-button:hover {
      background: #6b8fd4;
    }

    .body-image {
      margin-top: 6px;
      background-color: #000000;
      border-radius: 8px;
    }

    .summary {
      font-size: 14px;
      font-weight: bold;
      background: transparent;
      color: #ffffff;
      text-shadow: none;
    }

    .time {
      font-size: 12px;
      font-weight: bold;
      background: transparent;
      color: #cccccc;
      text-shadow: none;
      margin-right: 18px;
    }

    .body {
      font-size: 13px;
      font-weight: normal;
      background: transparent;
      color: #cccccc;
      text-shadow: none;
    }

    .control-center {
      background: #000000;
      border: 2px solid #5277C3;
                border-radius: 8px;
    }

    .control-center-list {
      background: #000000;
    }

    .control-center-list-placeholder {
      opacity: 0.5;
      background: #000000;
    }

    .blank-window {
      background: transparent;
    }

    .floating-notifications {
      background: transparent;
    }

    .widget-title {
      color: #ffffff;
      background: #000000;
      padding: 5px 10px;
      margin: 10px 10px 5px 10px;
      font-size: 1.2em;
      font-weight: bold;
    }

    .widget-title > button {
      font-size: initial;
      color: #000000;
      text-shadow: none;
      background: #5277C3;
      box-shadow: none;
      border-radius: 8px;
      padding: 4px 10px;
    }

    .widget-title > button:hover {
      background: #6b8fd4;
    }

    .widget-dnd {
      background: #000000;
      padding: 5px 10px;
      margin: 5px 10px;
      border-radius: 8px;
      font-size: large;
      color: #ffffff;
    }

    .widget-dnd > switch {
      border-radius: 8px;
      background: #000000;
      border: 1px solid #5277C3;
    }

    .widget-dnd > switch:checked {
      background: #5277C3;
    }

    .widget-dnd > switch slider {
      background: #ffffff;
      border-radius: 8px;
    }

    .widget-inhibitors {
      margin: 5px 10px;
      padding: 5px 10px;
      background: #000000;
      color: #ffffff;
      font-size: large;
      border-radius: 8px;
    }

    .widget-inhibitors > button {
      font-size: initial;
      color: #000000;
      background: #5277C3;
      box-shadow: none;
      border-radius: 8px;
      padding: 4px 10px;
    }

    .widget-inhibitors > button:hover {
      background: #6b8fd4;
    }
  '';

  programs.home-manager.enable = true;
}
