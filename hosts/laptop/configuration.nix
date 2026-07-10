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

  # Host-specific hardware workarounds
  boot.blacklistedKernelModules = [ "tpm_crb" "tpm_tis" "tpm" ];

  # Host identification
  networking.hostName = "lenny";

  # Host-specific user details
  users.users.drew = {
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  # Host-specific virtualization options
  virtualisation.docker.enable = true;

  # Power management
  services.logind.settings.Login.HandleLidSwitch = "ignore";

  # System state version
  system.stateVersion = "25.11";
}
