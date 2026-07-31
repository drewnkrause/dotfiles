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

    # Services
    ../../modules/system/caddy.nix
    ../../modules/system/adguardhome.nix
    ../../modules/system/vaultwarden.nix
    ../../modules/system/navidrome.nix
    ../../modules/system/samba.nix

    # Custom applications and containers
    ../../modules/containers/default.nix
    ../../modules/timers/fire-watcher.nix
  ];

  home-manager.users.drew = import ../../users/drew/cli.nix;



  # Host identification
  networking.hostName = "dennis";

  # Storage mounts
  fileSystems."/mnt" = {
    device = "/dev/disk/by-uuid/9d4382c6-8d82-4628-aa29-e9c1b21d0f0a";
    fsType = "ext4";
    options = [ "defaults" "nofail" ];
  };

  # Host-specific user details
  users.groups.media = {};
  users.users.drew = {
    extraGroups = [ "networkmanager" "wheel" "docker" "media" ];
  };

  # Host-specific system packages
  environment.systemPackages = with pkgs; [
    sops
    age
    (pkgs.python313.withPackages (ps: with ps; [
      requests
    ]))
  ];

  # Host-specific service enablement/configuration
  services.fire-danger-watcher = {
    enable = true;
    ntfyTopic = "cass_fire_danger";
    county = "Cass";
  };

  # Host-specific firewall settings
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # System state version
  system.stateVersion = "25.11";
}
