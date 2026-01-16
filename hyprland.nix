{
  pkgs,
  config,
  lib,
  osConfig,
  ...
}:
let
  themes = pkgs.callPackage ./themes.nix { };
in
{

  home.packages = with pkgs; [
    nautilus
    pavucontrol
    brightnessctl

    (pkgs.writeShellScriptBin "x-www-browser" ''
      exec ${osConfig.personal.browser} "$@"
    '')
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
      "DP-1,highres,auto-up,1.5,transform,0"
      "DP-3,highres,auto-up,2,transform,0" # puget external monitor
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
      "$mod + SHIFT, Return, exec, ${osConfig.personal.browser}"
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

      "$mod + Shift + Ctrl, H, movecurrentworkspacetomonitor, l"
      "$mod + Shift + Ctrl, L, movecurrentworkspacetomonitor, r"

      "$mod, H, movefocus, l"
      "$mod, J, movefocus, d"
      "$mod, K, movefocus, u"
      "$mod, L, movefocus, r"

      "$mod + Shift, H, movewindow, l"
      "$mod + Shift, J, movewindow, d"
      "$mod + Shift, K, movewindow, u"
      "$mod + Shift, L, movewindow, r"

      "$mod + Shift + Ctrl, Right, resizeactive, 10 0"
      "$mod + Shift + Ctrl, Left, resizeactive, -10 0"
      "$mod + Shift + Ctrl, Up, resizeactive, 0 -10"
      "$mod + Shift + Ctrl, Down, resizeactive, 0 10"

      "$mod,mouse:272,movewindow"
      # "$mod,mouse:273,resizewindow"

      "$mod + Alt, Backspace, exec, hyprctl switchxkblayout all next"

      ", Print, exec, grimblast copy area"
      "SHIFT, Print, exec, grimblast copysave area"
      "CTRL, Print, exec, grimblast copy screen"
      "CTRL + SHIFT, Print, exec, grimblast copysave screen"

      ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
      ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
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

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };

      animations = {
        enabled = true;
        fade_in = {
          duration = 300;
          bezier = "easeOutQuint";
        };
        fade_out = {
          duration = 300;
          bezier = "easeOutQuint";
        };
      };

      background = [
        {
          path = "/home/owi/nixos/bg-dark.jpeg";
          blur_passes = 0;
          blur_size = 0;
        }
      ];

      input-field = [
        {
          size = "200, 50";
          halign = "center";
          valign = "bottom";
          position = "0, 100";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_family = "TX-02";
          font_color = "rgba(${lib.strings.removePrefix "#" themes.dark.foreground}ff)";
          inner_color = "rgba(${lib.strings.removePrefix "#" themes.dark.background}aa)";
          outer_color = "rgba(${lib.strings.removePrefix "#" themes.dark.foreground}88)";
          fail_color = "rgba(${lib.strings.removePrefix "#" themes.dark.red}ff)";
          capslock_color = "rgba(${lib.strings.removePrefix "#" themes.dark.yellow}ff)";
          outline_thickness = 4;
          placeholder_text = "You shall not pass!";
          rounding = 2;
          shadow_passes = 3;
        }
      ];
    };
  };

  services.screen-locker.enable = false;

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
        "/home/owi/nixos/bg-dark.jpeg"
        "/home/owi/nixos/bg-light.jpeg"
      ];
      wallpaper = ", /home/owi/nixos/bg-dark.jpeg";
    };
  };

  services.hyprsunset = {
    enable = true;
    settings = {
      max-gamma = 150;

      profile = [
        {
          time = "7:30";
          identity = true;
          temperature = 6500;
        }
        {
          time = "19:00";
          temperature = 2500;
          gamma = 0.8;
        }
      ];
    };
  };

  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-uri-dark = "file:///home/owi/nixos/bg-dark.jpeg";
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
      wallpaper = ''
        ${pkgs.hyprland}/bin/hyprctl hyprpaper reload ",/home/owi/nixos/bg-dark.jpeg"
      '';
      color-scheme = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
      '';
      nvim = ''
        for addr in `${pkgs.findutils}/bin/find /tmp/ -name '*.nvim.pipe'`; do
            ${pkgs.neovim}/bin/nvim --server $addr --remote-send "<Esc>:set bg=dark<CR>"
        done
      '';
    };
    lightModeScripts = {
      wallpaper = ''
        ${pkgs.hyprland}/bin/hyprctl hyprpaper reload ",/home/owi/nixos/bg-light.jpeg"
      '';
      color-scheme = ''
        ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
      '';
      nvim = ''
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
