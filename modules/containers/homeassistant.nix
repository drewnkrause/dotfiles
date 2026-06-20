{ config, ... }:

{
  virtualisation.oci-containers.containers = {
    "govee2mqtt" = {
      image = "ghcr.io/wez/govee2mqtt:latest";
      environment = {
        "GOVEE_EMAIL" = "drewkrause2@gmail.com";
        "GOVEE_MQTT_HOST" = "localhost";
        "GOVEE_MQTT_PORT" = "1883";
        "GOVEE_TEMPERATURE_SCALE" = "F";
        "RUST_LOG_STYLE" = "always";
        "TZ" = "America/Chicago";
      };
      environmentFiles = [ config.sops.secrets.govee_env.path ];
      log-driver = "journald";
      extraOptions = [
        "--network=host"
      ];
    };

    "home-assistant-eclipse-mosquitto" = {
      image = "eclipse-mosquitto";
      ports = [
        "1883:1883/tcp"
      ];
      log-driver = "journald";
    };

    "homeassistant" = {
      image = "ghcr.io/home-assistant/home-assistant:stable";
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "/var/lib/HomeAssistant:/config:rw"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network=host"
      ];
    };
  };
}
