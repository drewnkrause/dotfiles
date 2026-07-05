{ ... }:

{
  virtualisation.oci-containers.containers."factorio" = {
    image = "docker.io/factoriotools/factorio:stable";
    environment = {
      "DLC_SPACE_AGE" = "false";
    };
    volumes = [
      "/var/lib/factorio:/factorio:rw"
    ];
    ports = [
      "34197:34197/udp"
      "27015:27015/tcp"
    ];
    log-driver = "journald";
    labels = {
      "io.containers.autoupdate" = "registry";
    };
  };
}
