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
    # ../../modules/system/tailscale.nix
    ../../modules/system/mango.nix
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

  environment.systemPackages = with pkgs; [
    mesa
    libglvnd
    xdg-desktop-portal-gtk
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  services.pipewire.enable = true

  system.stateVersion = "25.05";
}

