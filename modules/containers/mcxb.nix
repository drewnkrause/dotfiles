{ ... }:

{
  virtualisation.oci-containers.containers."mcxb-mcxboxbroadcast" = {
    image = "ghcr.io/mcxboxbroadcast/standalone:master";
    volumes = [
      "/var/lib/MCXboxBroadcast:/opt/app/config:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=host"
    ];
  };
}
