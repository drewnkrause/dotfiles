{ config, pkgs, ... }:

{
  imports = [
    ./setup.nix
    # ./factorio.nix
    ./homeassistant.nix
    ./mc-server.nix
    ./terraria-server.nix
    ./mcxb.nix
    ./asknavidrome.nix
    ./musicassistant.nix
  ];
}
