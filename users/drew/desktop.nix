{ config, pkgs, inputs, ... }:

{
  imports = [
    ./cli.nix
    ./modules/desktop/foot.nix
    ./modules/desktop/noctalia.nix
    # ./modules/desktop/mango.nix
    ./modules/desktop/niri.nix
  ];

  home.packages = with pkgs; [
    firefox
    nemo
    peazip
    vscode
    spotify
  ];
}
