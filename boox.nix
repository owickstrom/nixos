{ config, pkgs, ... }:

let
  mira-js = pkgs.buildNpmPackage rec {
    pname = "boox-mira";
    version = "0.2.8";

    src = pkgs.fetchFromGitHub {
      owner = "ipodnerd3019";
      repo = "mira-js";
      rev = "3bcb25d9e60508c9a3b250afa97ed1bd7cbfb4ff";
      hash = "sha256-mNQS2nOH8WIkKAnTOtWVQ6NVDQk+ZXJT/IUGEZPw/bA=";
    };

    dontNpmBuild = true;

    npmDepsHash = "sha256-itgcEa69sMHZuMfXiwhOmTeK1RuPYD0z4YyOUDe+xjA=";

    buildInputs = [
      pkgs.libusb1
      pkgs.hidapi
    ];
    nativeBuildInputs = [ pkgs.pkg-config ];

    LIBUSB_LIB_DIR = "${pkgs.libusb1}/lib";
    HIDAPI_LIB_DIR = "${pkgs.hidapi}/lib";
  };
in
{
  environment.systemPackages = [ mira-js ];

  services.udev.extraRules = ''
    # Boox Mira HID device rules
    SUBSYSTEM=="input", GROUP="input", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0416", ATTRS{idProduct}=="5020", MODE="0666",
    GROUP="plugdev"
      KERNEL=="hidraw*", ATTRS{idVendor}=="0416", ATTRS{idProduct}=="5020", MODE="0666",
    GROUP="plugdev"
  '';

  users.groups.plugdev = { };
  users.users.owi.extraGroups = [
    "plugdev"
    "input"
  ];
}
