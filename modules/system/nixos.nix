{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  # Bootloader & Kernel Forwarding
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # Networking
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # X11 Keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Extra locales
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Passwordless sudo for wheel group
  security.sudo.wheelNeedsPassword = false;
}
