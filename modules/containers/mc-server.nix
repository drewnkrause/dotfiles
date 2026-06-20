{ ... }:

{
  virtualisation.oci-containers.containers."mc-server-bds" = {
    image = "itzg/minecraft-bedrock-server";
    environment = {
      "DIFFICULTY" = "hard";
      "EULA" = "TRUE";
      "LEVEL_NAME" = "§l§4C§fC§4U";
      "MAX_PLAYERS" = "100";
      "PLAYER_IDLE_TIMEOUT" = "0";
      "SERVER_NAME" = "§l§4C§fC§4U";
    };
    volumes = [
      "/var/lib/mc-server/data:/data:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=host"
    ];
  };
}
