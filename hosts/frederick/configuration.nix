{ config, pkgs, ... }:

{
  imports = [
    # Hardware scan results
    ./hardware-configuration.nix

    # Shared configurations
    ../../modules/system/nixos.nix
    ../../modules/system/sops.nix
    ../../modules/system/ssh.nix
    ../../modules/system/tailscale.nix
  ];

  # Host identification
  networking.hostName = "frederick";

  # Host-specific user details
  users.groups.media = {};
  users.users.drew = {
    extraGroups = [ "networkmanager" "wheel" "docker" "media" ];
  };
}
