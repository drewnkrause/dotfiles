{ pkgs, ... }:

{
  programs.niri = {
    # package = pkgs.niri.overrideAttrs (old: {
    #   buildInputs = (old.buildInputs or []) ++ [ pkgs.libdisplay-info ];
    # });
    enable = true;
  };
}
