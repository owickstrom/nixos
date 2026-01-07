{ pkgs, config, ... }:
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

    #network {
      color: ${theme.blue};
      background-color: ${theme.background};
    }

    #bluetooth {
      color: ${theme.blue};
      background-color: ${theme.background};
    }

    #network.disconnected,
    #bluetooth.disconnected {
      color: ${theme.red};
      background-color: ${theme.background};
    }

    #backlight {
      color: ${theme.foreground};
      background-color: ${theme.background};
    }

    #clock,
    #language {
      color: ${theme.foreground};
      background-color: ${theme.background};
    }

    #wireplumber {
      color: ${theme.foreground};
      background-color: ${theme.background};
    }

    #battery {
      color: ${theme.yellow};
      background-color: ${theme.background};
    }

    #battery.charging, #battery.plugged {
      color: ${theme.green};
      background-color: ${theme.background};
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
      "backlight"
      "hyprland/language"
      "wireplumber"
      "battery"
      "clock"
    ];
    backlight = {
      device = "intel_backlight";
      format = "☼ {percent}%";
    };
    battery = {
      format = "{icon}  {capacity}%";
      "format-icons" = [
        ""
        ""
        ""
        ""
        ""
      ];
    };
    clock = {
      format-alt = "{:%a, %d. %b  %H:%M}";
    };
    network = {
      format = "{icon}";
      format-wifi = "{icon}";
      format-ethernet = "󰊗";
      format-disconnected = "{icon} "; # An empty format will hide the module.
      tooltip-format = "{ifname} via {gwaddr} 󰊗";
      tooltip-format-wifi = "{essid} ({signalStrength}%)";
      tooltip-format-ethernet = "{ifname} {ipaddr}/{cidr} ";
      tooltip-format-disconnected = "Disconnected";
      max-length = 50;
      "format-icons" = [ "" ];
      on-click = "ghostty -e nmtui";
    };
    "hyprland/language" = {
      format = " {}";
      on-click = "hyprctl switchxkblayout all next";
      format-sv = "SV";
      format-en = "EN";
    };
    wireplumber = {
      "format" = "{icon}  {volume}%";
      "format-muted" = "";
      "format-icons" = [
        ""
        ""
        ""
      ];
      "on-click" = "pwvucontrol";
      "max-volume" = 150;
      "scroll-step" = 0.2;
    };
    bluetooth = {
      "format" = "";
      "format-connected" = " {device_alias}";
      "format-connected-battery" = " {device_alias} {device_battery_percentage}%";
      "on-click" = "blueberry";
    };
  };

  xdg.configFile."waybar/style-light.css".text = makeStyles themes.light;

  xdg.configFile."waybar/style-dark.css".text = makeStyles themes.dark;

  xdg.configFile."waybar/style.css".text = makeStyles themes.dark;

  home.packages = [ pkgs.blueberry ];
}
