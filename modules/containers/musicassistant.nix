{ ... }:

{
  virtualisation.oci-containers.containers."music-assistant" = {
    image = "ghcr.io/music-assistant/server:latest";
    volumes = [
      "/var/lib/music-assistant:/data"
    ];
    extraOptions = [
      "--network=host" 
      "--dns=1.1.1.1"
      "--dns=1.0.0.1"
    ];
    labels = {
      "io.containers.autoupdate" = "registry";
    };
  };
}
