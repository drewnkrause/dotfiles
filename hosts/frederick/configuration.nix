{ config, pkgs, inputs, ... }:

{
  imports = [
    ../../modules/system/home-manager.nix

    # Hardware scan results
    ./hardware-configuration.nix

    # Shared configurations
    ../../modules/system/nixos.nix
    ../../modules/system/sops.nix
    ../../modules/system/ssh.nix
    ../../modules/system/tailscale.nix
    ../../modules/system/niri.nix
    ../../modules/system/noctalia-greeter.nix
  ];

  home-manager.users.drew = import ../../users/drew/desktop.nix;


  # Host identification
  networking.hostName = "frederick";

  # Host-specific user details
  users.groups.media = {};
  users.users.drew = {
    extraGroups = [ "networkmanager" "wheel" "docker" "media" ];
  };

  hardware.graphics = {
    enable = true;
  };

  services.pipewire.enable = true;

  environment.systemPackages = with pkgs; [
    mesa
    libglvnd
    # xdg-desktop-portal-gtk
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # noctalia recommended services
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  services.tuned.enable = true;
  services.upower.enable = true;

  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = false;
  
  # environment.pathsToLink = [ "/share/applications" "/share/xdg-desktop/portal" ];
  system.stateVersion = "25.05";
}

