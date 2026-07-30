{ config, pkgs, inputs, ... }:

{
  imports = [
    ./cli.nix
    ./modules/desktop/foot.nix
    ./modules/desktop/noctalia.nix
    ./modules/desktop/mango.nix
  ];

  home.package = with pkgs; [
    firefox
    nemo
    peazip
    vscode
  ];
}
