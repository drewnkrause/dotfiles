{ config, ... }:

{
  sops = {
    defaultSopsFile = ../../secrets.yaml;
    age.keyFile = "/home/drew/.config/sops/age/keys.txt";
    
    # Define the base secrets used by the hosts
    secrets.tailscale_key = {};
  };
}
