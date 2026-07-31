{ config, pkgs, inputs, ... }:

{
  imports = [
    ./modules/zsh.nix
    ./modules/git.nix
    ./modules/hx.nix
    ./modules/starship.nix
  ];

  # Home Manager details
  home.username = "drew";
  home.homeDirectory = "/home/drew";
  home.stateVersion = "25.11";

  home.packages = [
    pkgs.fastfetch
  ];

  home.sessionVariables = {
    EDITOR = "hx";
    NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.npm-global/bin"
  ];

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
  programs.neovim = {
    enable = true;
    withPython3 = false;
    withRuby = false;
  };
}
