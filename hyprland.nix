{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    glib
    gsettings-desktop-schemas
    nautilus
  ];

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    input = {
      kb_options = "ctrl:nocaps";
    };
    general.gaps_in = 5;
    general.gaps_out = 5;
    animation = [
      "workspaces, 1, 1, default"
      "windows, 1, 1, default"
      "fade, 1, 1, default"
    ];

    misc = {
      disable_splash_rendering = true;
      disable_hyprland_logo = true;
    };

    bind = [
      "$mod, Q, killactive"
      "$mod + SHIFT, Q, killactive"
      "$mod, F, fullscreen"
      "$mod + SHIFT, F, togglefloating"
      "$mod, Return, exec, ghostty"
      "$mod + SHIFT, Return, exec, firefox"
      "$mod + SHIFT, N, exec, nautilus"
      "$mod, T, exec, darkman toggle"

      "$mod, Left, movefocus, l"
      "$mod, Right, movefocus, r"
      "$mod, Up, movefocus, u"
      "$mod, Down, movefocus, d"

      "$mod, H, movefocus, l"
      "$mod, J, movefocus, d"
      "$mod, K, movefocus, u"
      "$mod, L, movefocus, r"

      ", Print, exec, grimblast copy area"
      "SHIFT, Print, exec, grimblast copysave area"
    ]
    ++ (
      # workspaces
      # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
      builtins.concatLists (
        builtins.genList (
          i:
          let
            ws = i + 1;
          in
          [
            "$mod, code:1${toString i}, workspace, ${toString ws}"
            "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        ) 9
      )
    );
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
  programs.waybar.settings.main = {
    modules-left = [ "hyprland/workspaces" ];
    modules-center = [ "hyprland/window" ];
    modules-right = [
      "network"
      "battery"
      "clock"
    ];
    battery = {
      format = "{capacity}%";
    };
    clock = {
      format-alt = "{:%a, %d. %b  %H:%M}";
    };
    network = {
      format = "{ifname}";
      format-wifi = "{essid} ({signalStrength}%)";
      format-ethernet = "{ipaddr}/{cidr} 󰊗";
      format-disconnected = ""; # An empty format will hide the module.
      tooltip-format = "{ifname} via {gwaddr} 󰊗";
      tooltip-format-wifi = "{essid} ({signalStrength}%)";
      tooltip-format-ethernet = "{ifname} ";
      tooltip-format-disconnected = "Disconnected";
      max-length = 50;
    };
  };
  programs.waybar.style = ''
    @import url("file://${pkgs.waybar}/etc/xdg/waybar/style.css");

    * {
      font-family: Alegreya Sans, sans-serif;
      font-weight: 600;
      font-size: 12px;
    }

    window#waybar {
      background-color: #000;
      border-bottom: none;
    }

    #workspaces button.active {
      background-color: rgba(255, 255, 255, 0.2);
    }
  '';

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = "/etc/nixos/bg.jpeg";
      wallpaper = ", /etc/nixos/bg.jpeg";
    };
  };

  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-uri-dark = "file:///etc/nixos/bg.jpeg";
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    font = {
      name = "Alegreya Sans";
      size = 11;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      # package = pkgs.kdePackages.breeze-icons;
      # name = "Breeze-Dark";
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };
  #
  # qt = {
  #   enable = true;
  #   style = {
  #     name = "adwaita-dark";
  #   };
  # };
  #

  services.darkman = {
    enable = true;
    darkModeScripts = {
      color-scheme = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
        for addr in `${pkgs.findutils}/bin/find /tmp/ -name '*.nvim.pipe'`; do
            ${pkgs.neovim}/bin/nvim --server $addr --remote-send ":set bg=dark<CR>"
        done
      '';
    };
    lightModeScripts = {
      color-scheme = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
        for addr in `${pkgs.findutils}/bin/find /tmp/ -name '*.nvim.pipe'`; do
            ${pkgs.neovim}/bin/nvim --server $addr --remote-send ":set bg=light<CR>"
        done
      '';
    };
    settings = {
      lat = 59.19;
      lng = 18.4;
      usegeoclue = false;
    };
  };
}
