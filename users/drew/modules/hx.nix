{ config, pkgs, ... }: 

{
  home.packages = [
     pkgs.nixd
  ];
  
  programs.helix = {
    enable = true;
    settings = {
      theme = "gruvbox";
      editor = {
        true-color = true;
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        indent-guides.render = true;
        indent-guides.character = "▏";
      };
    };
  };
}
