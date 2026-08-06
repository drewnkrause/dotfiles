{ inputs, pkgs, ... }:

{
  imports = [
  inputs.noctalia-greeter.nixosModules.default
];

programs.noctalia-greeter = {
  enable = true;

  # Optional configuration
  greeter-args = "";
  # Full declarative greeter.toml (overwritten on each activation).
  # See examples/greeter.toml for every key (appearance.palette, output, …).
  settings = {
    cursor = {
      theme = "Bibata-Modern-Classic";
      size = 16;
      path = "${pkgs.bibata-cursors}/share/icons";
    };
    keyboard = {
      layout = "us";
    };
  };
};
}
