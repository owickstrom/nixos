{
  pkgs,
  config,
  lib,
  ...
}:
let
  themes = pkgs.callPackage ./themes.nix { };
in
{
  home.packages = with pkgs; [
    nautilus
    pavucontrol
  ];

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    input = {
      kb_layout = "us,se";
      kb_options = "ctrl:nocaps, compose:ralt";
    };

    monitor = [
      "eDP-1,highres,auto-left,1.5,transform,0"
      "HDMI-A-2,highres,auto-down,2,transform,1"
      "DP-1,highres,auto-up,2,transform,0"
      ", preferred, auto, 1"
    ];

    general.gaps_in = 2;
    general.gaps_out = 4;
    general.border_size = 2;
    general."col.inactive_border" =
      "rgba(${lib.strings.removePrefix "#" themes.dark.white}aa) rgba(${lib.strings.removePrefix "#" themes.dark.white}44) 45deg";
    general."col.active_border" =
      "rgba(${lib.strings.removePrefix "#" themes.dark.brightBlue}ff) rgba(${lib.strings.removePrefix "#" themes.dark.blue}aa) 45deg";

    decoration = {
      shadow.enabled = false;
      # dim_inactive = true;
      # dim_strength = 0.1;

      active_opacity = 1;
      inactive_opacity = 0.9;

      blur = {
        enabled = true;
        size = 8;
        passes = 1;
        new_optimizations = true;
      };
    };

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
      "$mod, Space, exec, rofi -show run"
      "$mod, T, exec, darkman toggle"
      "$mod + SHIFT, Escape, exec, hyprlock"
      "$mod + SHIFT, E, exit"

      "$mod, R, layoutmsg, orientationnext"

      "$mod, Left, movefocus, l"
      "$mod, Right, movefocus, r"
      "$mod, Up, movefocus, u"
      "$mod, Down, movefocus, d"

      "$mod + Shift, Left, movewindow, l"
      "$mod + Shift, Right, movewindow, r"
      "$mod + Shift, Up, movewindow, u"
      "$mod + Shift, Down, movewindow, d"

      "$mod, H, movefocus, l"
      "$mod, J, movefocus, d"
      "$mod, K, movefocus, u"
      "$mod, L, movefocus, r"

      "$mod + Shift, H, movewindow, l"
      "$mod + Shift, J, movewindow, d"
      "$mod + Shift, K, movewindow, u"
      "$mod + Shift, L, movewindow, r"

      "$mod + Alt, Backspace, exec, hyprctl switchxkblayout all next"

      ", Print, exec, grimblast copy area"
      "SHIFT, Print, exec, grimblast copysave area"
      "CTRL, Print, exec, grimblast copy screen"
      "CTRL + SHIFT, Print, exec, grimblast copysave screen"
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

  programs.hyprlock.enable = true;

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };

      listener = [
        {
          timeout = 900;
          on-timeout = "hyprlock";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "/etc/nixos/personal/bg-dark.jpeg"
        "/etc/nixos/personal/bg-light.jpeg"
      ];
      wallpaper = ", /etc/nixos/personal/bg-dark.jpeg";
    };
  };

  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-uri-dark = "file:///etc/nixos/personal/bg-dark.jpeg";
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home.pointerCursor = {
    hyprcursor.enable = true;
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;

  };

  gtk = {
    enable = true;
    font = {
      name = "Alegreya Sans";
      size = 12;
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

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [
      "hyprland"
      "gtk"
    ]; # Prioritize hyprland for screen sharing, gtk for settings
  };

  services.darkman = {
    enable = true;
    darkModeScripts = {
      color-scheme = ''
        ${pkgs.hyprland}/bin/hyprctl hyprpaper reload ",/etc/nixos/personal/bg-dark.jpeg"
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
        for addr in `${pkgs.findutils}/bin/find /tmp/ -name '*.nvim.pipe'`; do
            ${pkgs.neovim}/bin/nvim --server $addr --remote-send "<Esc>:set bg=dark<CR>"
        done
      '';
    };
    lightModeScripts = {
      color-scheme = ''
        ${pkgs.hyprland}/bin/hyprctl hyprpaper reload ",/etc/nixos/personal/bg-light.jpeg"
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
        for addr in `${pkgs.findutils}/bin/find /tmp/ -name '*.nvim.pipe'`; do
            ${pkgs.neovim}/bin/nvim --server $addr --remote-send "<Esc>:set bg=light<CR>"
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
