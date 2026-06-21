{ pkgs, ... }:

{
  # Time zone and Locale
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  # Shell configuration
  programs.zsh.enable = true;

  # Nix configuration
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages by default
  nixpkgs.config.allowUnfree = true;

  # Common packages
  environment.systemPackages = with pkgs; [
    p7zip
  ];

  # Base user definition for Drew (merged with host-specific config)
  users.users.drew = {
    isNormalUser = true;
    description = "Drew Krause";
    shell = pkgs.zsh;
  };
}
