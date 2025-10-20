{ pkgs, config, ... }:
let
  themes = pkgs.callPackage ./themes.nix { };
  makeStyles = theme: ''
    @import url("file://${pkgs.waybar}/etc/xdg/waybar/style.css");

    * {
      font-family: Alegreya Sans, sans-serif;
      font-weight: 600;
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

    #network {
      color: ${theme.blue};
      background-color: ${theme.background};
    }

    #clock {
      color: ${theme.foreground};
      background-color: ${theme.background};
    }

    #battery {
      color: ${theme.yellow};
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

  xdg.configFile."waybar/style-light.css".text = makeStyles themes.light;

  xdg.configFile."waybar/style-dark.css".text = makeStyles themes.dark;
}
