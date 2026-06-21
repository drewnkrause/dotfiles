{ config, ... }:

{
  sops.secrets.navidrome_env = {};

  users.users.navidrome.extraGroups = [ "media" ];

  services.navidrome = {
    enable = true;
    environmentFile = config.sops.secrets.navidrome_env.path;
    settings = {
      Address = "0.0.0.0";
      Port = 4533;
      MusicFolder = "/mnt/media/music";

      # Optional but helpful for custom tracks
      ScanInterval = "1m"; 
      SessionTimeout = "24h";
    };
  };
}
