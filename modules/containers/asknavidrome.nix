
{ config, ... }:

{
  sops.secrets.asknavidrome_env = {};

  virtualisation.oci-containers.containers."asknavidrome" = {
    image = "ghcr.io/rosskouk/asknavidrome:latest";
    ports = [ "5000:5000/tcp" ];
    environment = {
      "NAVI_SONG_COUNT" = "50";
      "NAVI_URL" = "https://ss.drewkrause.dev";
      "NAVI_USER" = "alexa";
      "NAVI_PORT" = "443";
      "NAVI_API_PATH" = "/rest";
      "NAVI_API_VER" = "1.16.1";
      "NAVI_DEBUG" = "0";
    };
    environmentFiles = [ config.sops.secrets.asknavidrome_env.path ];
    log-driver = "journald";
  };
}
