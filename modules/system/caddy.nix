{ config, pkgs, ... }:

{
  # Ensure Caddy is enabled
  services.caddy = {
    enable = true;
    
    # Global options (replaces the {} block in Caddyfile)
    globalConfig = ''
      email drewkrause2@gmail.com
    '';

    virtualHosts = {
      # Redirect non-www to www
      "drewkrause.dev" = {
        extraConfig = "redir https://www.drewkrause.dev{uri}";
      };

      # Main Website
      "www.drewkrause.dev" = {
        extraConfig = ''
          root * /var/www/html
          file_server
          
          handle /Carpetball/* {
            rewrite * /Carpetball/Carpetball.html
          }
          
          handle /Cardboardy/* {
            header Cross-Origin-Embedder-Policy "require-corp"
            header Cross-Origin-Opener-Policy "same-origin"
            try_files {path} /Cardboardy/cardboardy.html
          }
        '';
      };

      # Simple Reverse Proxies
      "ha.drewkrause.dev".extraConfig = "reverse_proxy localhost:8123";
      "poker.drewkrause.dev".extraConfig = "reverse_proxy localhost:3000";
      "vw.drewkrause.dev".extraConfig = "reverse_proxy localhost:6574";

      # Custom Port Listeners
      "www.drewkrause.dev:3241".extraConfig = "reverse_proxy localhost:3240";
      "www.drewkrause.dev:3078".extraConfig = "reverse_proxy localhost:3077";
    };
  };

  # Open the necessary ports in the firewall
  networking.firewall.allowedTCPPorts = [ 80 443 3241 3078 ];
}
