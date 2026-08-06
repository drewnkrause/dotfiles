{ config, pkgs, inputs, ... }:

{
  imports = [
    ./cli.nix
    ./modules/desktop/foot.nix
    ./modules/desktop/noctalia.nix
    # ./modules/desktop/mango.nix
    ./modules/desktop/niri.nix
    inputs.zen-browser.homeModules.beta
  ];

  home.packages = with pkgs; [
    # firefox
    nemo
    peazip
    vscode
    spotify
  ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };
  
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark"; # or "Adwaita"
      package = pkgs.papirus-icon-theme; # or pkgs.adwaita-icon-theme
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk4.theme = config.gtk.theme;
  };
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16; # Logical size
  };
}
