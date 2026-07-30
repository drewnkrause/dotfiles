{ pkgs, config, inputs, ... }:

{
  imports = [
    ../../modules/system/home-manager.nix

    # The nixos-wsl module will need to be added to your flake inputs
    inputs.nixos-wsl.nixosModules.default

    # Shared base configuration
    ../../modules/system/common.nix
  ];

  home-manager.users.drew = import ../../users/drew/cli.nix;


  # WSL-specific configurations

  wsl.enable = true;
  wsl.defaultUser = "drew";
  wsl.ssh-agent.enable = true;

  networking.hostName = "wsl";

  # User configuration matching your other hosts (extended from common)
  users.users.drew = {
    extraGroups = [ "wheel" "docker" ];
  };

  # Development-focused CLI tools from your scoop list
  environment.systemPackages = with pkgs; [
    # Development & Version Control
    git
    nodejs_22 
    corepack
    jdk17 
    jdt-language-server # Matches jdtls
    ripgrep
    fzf
    wget
    openssl
    go
    gopls
    uv
    
    # Text Processing & Utilities
    helix
    neovim
    pandoc
    typst
    ffmpeg
    
    # Prompt & Shell
    starship
    zoxide
  ];

  # Re-using your existing shell and secret configurations
  programs.nix-ld.enable = true;
  
  system.stateVersion = "25.11";
}
