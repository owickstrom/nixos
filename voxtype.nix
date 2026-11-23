# Voxtype: voice dictation. Super+Shift+F8 to start, speak (text streams in), F8 again to stop.
{
  pkgs,
  config,
  lib,
  ...
}:
let
  voxtype = pkgs.callPackage ./voxtype-package.nix { };
  bin = "${voxtype}/bin/voxtype";
  mod = "SUPER";
in
{
  home.packages = [ voxtype ];

  xdg.configFile."voxtype/config.toml".source = ./voxtype/config.toml;

  systemd.user.services.voxtype = {
    Unit = {
      Description = "Voxtype push-to-talk dictation daemon";
      After = [
        "graphical-session.target"
        "pipewire.service"
      ];
      PartOf = [ "graphical-session.target" ];
      X-Restart-Triggers = [ "${config.xdg.configFile."voxtype/config.toml".source}" ];
    };
    Service = {
      ExecStart = "${bin} daemon";
      # hyprctl for the submap hooks in config.toml.
      Environment = [ "PATH=${lib.makeBinPath [ pkgs.hyprland ]}:/run/current-system/sw/bin" ];
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # Same chord family as the mira binds in hyprland.nix.
  # Super+Shift+F8 toggles: press to start, press again to stop. It used to be
  # push-to-talk (bind on press, bindr on release), but whisper streaming types
  # at the cursor while recording, and those synthetic key events clobber
  # libinput's held-key tracking so the release bind never fires.
  wayland.windowManager.hyprland.settings = {
    bind = [ "${mod} + Shift, F8, exec, ${bin} record toggle" ];
  };

  # While voxtype types, Super/Shift may still be held, and the typed letters
  # would otherwise land on Super+Shift binds (Q kills the window...). The
  # pre/post_output_command hooks in config.toml switch into this submap, where
  # none of the main binds are active, for the duration of the typing. F12
  # escapes it by hand if voxtype dies in between. Submaps are ordered
  # keywords, so this has to be extraConfig rather than settings.
  wayland.windowManager.hyprland.extraConfig = ''
    submap = voxtype_suppress
    bind = , SUPER_L, exec, true
    bind = , SUPER_R, exec, true
    bind = , Control_L, exec, true
    bind = , Control_R, exec, true
    bind = , Alt_L, exec, true
    bind = , Alt_R, exec, true
    bind = , Shift_L, exec, true
    bind = , Shift_R, exec, true
    bind = , F12, submap, reset
    submap = reset
  '';

  # Waybar indicator; placed in the bar and styled in waybar.nix. The daemon
  # writes idle/recording/streaming/transcribing/stopped to its state file and
  # `status --follow` streams that as JSON with the state in `alt`. Waybar
  # hides a custom module whose formatted text is empty, so idle and stopped
  # map to "" and only the active states show a dot (coloured via CSS class).
  # An alt with no entry in format-icons renders as empty, so every state
  # the daemon can emit must be listed here or the dot vanishes.
  programs.waybar.settings.main."custom/voxtype" = {
    exec = "${bin} status --follow --format json";
    return-type = "json";
    format = "{icon}";
    format-icons = {
      idle = "";
      stopped = "";
      recording = "●";
      streaming = "●";
      transcribing = "●";
    };
    tooltip = true;
    on-click = "systemctl --user restart voxtype";
  };
}
