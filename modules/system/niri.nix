{ pkgs, inputs, ... }:

{
  environment.systemPackages = [ inputs.niri-scratchpad.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  programs.niri = {
    # package = pkgs.niri.overrideAttrs (old: {
    #   buildInputs = (old.buildInputs or []) ++ [ pkgs.libdisplay-info ];
    # });
    enable = true;
  };
}
