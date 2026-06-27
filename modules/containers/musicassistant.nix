{ ... }:

{
  virtualisation.oci-containers.containers."music-assistant" = {
    image = "ghcr.io/music-assistant/server:latest";
    volumes = [
      "/var/lib/music-assistant:/data"
      "/mnt/media/music:/media:ro" 
    ];
    extraOptions = [
      "--network=host" 
    ];
  };
}
