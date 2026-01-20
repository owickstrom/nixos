{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
let
  themes = pkgs.callPackage ./themes.nix { };
  makeStyles = theme: ''
    @import url("file://${pkgs.waybar}/etc/xdg/waybar/style.css");

    * {
      font-family: "TX-02 SemiCondensed";
      font-weight: 400;
      font-size: 12px;
    }

    window#waybar {
      background-color: ${theme.background};
      color: ${theme.foreground};
      border-bottom: none;
    }

    #workspaces button {
      color: ${theme.foreground};
    }
    #workspaces button.active {
      background-color: ${theme.selectionBackground};
    }

    #window * {
      font-family: "Alegreya Sans";
      font-size: 14px;
    }

    #clock {
      margin: 0 0 0 0.75em;
      padding: 0 0.75em;
      color: ${theme.foreground};
      background-color: transparent;
      border-left: 1px solid ${theme.brightBlack};
    }

    #network,
    #bluetooth,
    #backlight,
    #language,
    #wireplumber,
    #battery,
    #cpu {
      margin: 0;
      padding: 0 0.75em;
      color: ${theme.foreground};
      background-color: transparent;
    }

    #network,
    #network.disconnected {
      background-color: transparent;
      color: ${theme.foreground};
    }

    #bluetooth {
      color: ${theme.foreground};
    }

    #network.connected,
    #bluetooth.connected {
      color: ${theme.blue};
    }

    #backlight {
      color: ${theme.foreground};
    }

    #language {
      color: ${theme.foreground};
    }

    #wireplumber {
      color: ${theme.foreground};
    }

    #battery.charging, #battery.plugged {
      background: transparent;
      color: ${theme.green};
    }
    #battery.critical:not(.charging) {
      background: transparent;
      color: ${theme.red};
    }

    #cpu {
      color: ${theme.foreground};
    }
    #cpu.good {
      color: ${theme.foreground};
    }
    #cpu.warning {
      color: ${theme.yellow};
    }
    #cpu.critical {
      color: ${theme.red};
    }
  '';
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
  programs.waybar.settings.main = {
    modules-left = [ "hyprland/workspaces" ];
    modules-center = [ "hyprland/window" ];
    modules-right = [
      "bluetooth"
      "network"
    ]
    ++ lib.optional osConfig.personal.backlight.enabled "backlight"
    ++ [
      "hyprland/language"
      "wireplumber"
      "cpu"
      "battery"
      "clock"
    ];
    "hyprland/window" = {
      max-length = 32;
    };
    backlight = {
      device = osConfig.personal.backlight.device;
      format = ''<span weight="bold">SCR</span> {percent}%'';
    };
    battery = {
      format = ''<span weight="bold">BAT</span> {capacity}%'';
      min-length = 6;
      max-length = 7;
    };
    clock = {
      tooltip-format = "{:%a, %d. %b  %H:%M}";
      min-length = 5;
      max-length = 5;
    };
    network = {
      format = ''<span weight="bold">NET</span> NONE'';
      format-wifi = ''<span weight="bold">NET</span> {essid}'';
      format-ethernet = ''<span weight="bold">NET</span> ETHN'';
      format-disconnected = ''<span weight="bold">NET</span> DISC'';
      tooltip-format = "{ifname} via {gwaddr} 󰊗";
      tooltip-format-wifi = "{essid} ({signalStrength}%)";
      tooltip-format-ethernet = "{ifname} {ipaddr}/{cidr} ";
      tooltip-format-disconnected = "Disconnected";
      min-length = 6;
      max-length = 12;
      on-click = "ghostty -e nmtui";
    };
    "hyprland/language" = {
      format = ''<span weight="bold">KBD</span> {}'';
      on-click = "hyprctl switchxkblayout all next";
      format-sv = "SE";
      format-en = "US";
      min-length = 6;
      max-length = 6;
    };
    wireplumber = {
      format = ''<span weight="bold">VOL</span> {volume}%'';
      "on-click" = "pwvucontrol";
      "max-volume" = 150;
      "scroll-step" = 0.6;
      min-length = 6;
      max-length = 7;
    };
    bluetooth = {
      format = ''<span weight="bold">BLU</span> OFF'';
      "format-connected" = ''<span weight="bold">BLU</span> {device_alias}'';
      "format-connected-battery" = ''<span weight="bold">BLU</span> {device_battery_percentage}%'';
      "on-click" = "blueberry";
      min-length = 6;
      max-length = 12;
    };
    cpu = {
      interval = 10;
      format = ''<span weight="bold">CPU</span> {usage}%'';
      states = {
        good = 0;
        warning = 33;
        critical = 66;
      };
      on-click = "ghostty -e btop";
      min-length = 6;
      max-length = 7;
    };
  };

  xdg.configFile."waybar/style-light.css".text = makeStyles themes.light;

  xdg.configFile."waybar/style-dark.css".text = makeStyles themes.dark;

  xdg.configFile."waybar/style.css".text = makeStyles themes.dark;

  home.packages = [ pkgs.blueberry ];
}
