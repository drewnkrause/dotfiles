{ config, pkgs, ... }:

{
  imports = [
    # Hardware scan results
    ./hardware-configuration.nix

    # Shared configurations
    ../../modules/system/nixos.nix
    ../../modules/system/sops.nix
    ../../modules/system/ssh.nix
    # ../../modules/system/tailscale.nix
    ../../modules/system/mango.nix
  ];

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
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
