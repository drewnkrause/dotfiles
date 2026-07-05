{ pkgs, ... }:

{
  virtualisation.oci-containers.containers."tml" = {
    image = "docker.io/jacobsmile/tmodloader1.4:latest";

    ports = [
      "7777:7777/tcp"
    ];

    volumes = [
      "/var/lib/terraria-server:/data:rw"
    ];

    environment = {
      TMOD_AUTODOWNLOAD = "2669644269,2824688266,2824688072,2908170107,2563309347,2619954303,2816999612";
      TMOD_ENABLEDMODS = "2669644269,2824688266,2824688072,2908170107,2563309347,2619954303,2816999612";

      TMOD_WORLDNAME = "Calamity";     # Extracted from your world path name
      TMOD_MAXPLAYERS = "16";          # Matches maxplayers=16
      # TMOD_USECONFIGFILE = "Yes";       # Tells the container to prefer these env values
      TMOD_PASS = "N/A";
    };

    entrypoint = "/bin/sh";
    cmd = [
      "-c"
      "apt-get update && apt-get install -y libicu-dev && /terraria-server/entrypoint.sh"
    ];

    labels = {
      "io.containers.autoupdate" = "registry";
    };

    log-driver = "journald";

    extraOptions = [
      "--tty" 
      "--interactive"
    ];
  };
}
