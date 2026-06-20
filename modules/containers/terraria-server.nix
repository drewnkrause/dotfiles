{ pkgs, ... }:

{
  virtualisation.oci-containers.containers."tml" = {
    image = "localhost/compose2nix/tml";
    volumes = [
      "/var/lib/terraria-server/tModLoader:/home/tml/.local/share/Terraria/tModLoader:rw"
    ];
    ports = [
      "7777:7777/tcp"
    ];
    log-driver = "journald";
  };

  # Builds
  systemd.services."podman-build-tml" = {
    path = [ pkgs.podman pkgs.git ];
    serviceConfig = {
      Type = "oneshot";
      TimeoutSec = 300;
    };
    script = ''
      cd /home/drew/containers/terraria-server
      podman build -t compose2nix/tml --build-arg GID=1000 --build-arg UID=1000 .
    '';
  };
}
