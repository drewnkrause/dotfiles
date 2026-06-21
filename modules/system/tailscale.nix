{ config, ... }:

{
  services.tailscale = {
    enable = true;
    authKeyFile = config.sops.secrets.tailscale_key.path;
    extraUpFlags = [ "--accept-dns=false" "--advertise-exit-node" ];
  };
}
