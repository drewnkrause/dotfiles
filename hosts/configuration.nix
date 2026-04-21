{ pkgs, config, inputs, ... }:

{
  imports = [
    # The nixos-wsl module will need to be added to your flake inputs
    inputs.nixos-wsl.nixosModules.default
  ];

  wsl.enable = true;
  wsl.defaultUser = "drew";
  wsl.ssh-agent.enable = true;

  networking.hostName = "wsl";

  # Aligning with your existing locale settings
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  # User configuration matching your other hosts
  users.users.drew = {
    isNormalUser = true;
    description = "Drew Krause";
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  # Development-focused CLI tools from your scoop list
  environment.systemPackages = with pkgs; [
    # Development & Version Control
    git
    nodejs_22 # Closest stable to your scoop nodejs24
    python312
    jdk17 # Matches zulu17-jdk
    jdt-language-server # Matches jdtls
    ripgrep
    fzf
    
    # Text Processing & Utilities
    helix
    neovim
    pandoc
    typst
    p7zip
    ffmpeg
    yt-dlp
    
    # Prompt & Shell
    starship
    zoxide
  ];

  # Re-using your existing shell and secret configurations
  programs.zsh.enable = true;
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";
}
