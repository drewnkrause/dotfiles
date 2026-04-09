{ config, pkgs, ... }:

{  
  programs.git = {
    enable = true;
    settings = {
      user = {
        name  = "Drew Krause";
        email = "drewkrause2@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };
}
