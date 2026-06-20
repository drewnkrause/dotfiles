# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/system/caddy.nix
      ../../modules/containers/default.nix
      ../../modules/timers/fire-watcher.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  networking.hostName = "dennis"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  fileSystems."/mnt" = {
    device = "/dev/disk/by-uuid/9d4382c6-8d82-4628-aa29-e9c1b21d0f0a"; # Replace with your UUID
    fsType = "ext4"; # Change to btrfs, xfs, ntfs, etc., if applicable
    options = [ "defaults" "nofail" ]; 
};

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  sops = {
    defaultSopsFile = ../../secrets.yaml;
    # This is the path to the key we generated in Step 1
    age.keyFile = "/home/drew/.config/sops/age/keys.txt";
    
    # Define the secret we want to extract
    secrets.tailscale_key = {};
    secrets.govee_env = {};
    secrets.navidrome_env = {};
  };

  users.groups.media = {};
    
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.drew = {
    isNormalUser = true;
    description = "Drew Krause";
    extraGroups = [ "networkmanager" "wheel" "docker" "media"];
    packages = with pkgs; [];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAMrJpTBQa9XMg8ipPWJv5k1jO3xCaUIUmuq5O+awSTU"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    p7zip
    sops
    age
    (pkgs.python313.withPackages (ps: with ps; [
      requests
    ]))
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.:
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  programs.zsh.enable = true;
  services.tailscale = {
    enable = true;
    authKeyFile = config.sops.secrets.tailscale_key.path;
    extraUpFlags = ["--accept-dns=false" "--advertise-exit-node"];
  };
  services.openssh  = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "drew" ];
    };
  };

  services.fire-danger-watcher = {
    enable = true;
    ntfyTopic = "cass_fire_danger";
    county = "Cass";
  };

  services.adguardhome = {
    enable = true;
    openFirewall = false;
  };

  services.vaultwarden = {
    enable = true;
    config = {
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 6574;
      SIGNUPS_ALLOWED = "false";
    };
  };

  users.users.navidrome.extraGroups = [ "media" ];
  services.navidrome = {
    enable = true;
    environmentFile = config.sops.secrets.navidrome_env.path;
    settings = {
      Address = "0.0.0.0";
      Port = 4533;
      MusicFolder = "/mnt/media/music";

      # Optional but helpful for custom tracks
      ScanInterval = "1m"; 
      SessionTimeout = "24h";
    };
  };

  services.samba = {
    enable = true;
  
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "Dennis SMB";
        "netbios name" = "Dennis";
        "security" = "user";
        # Lock down access strictly to your home/dorm local subnets and your private Tailscale block
        "hosts allow" = [ "192.168.1." "10.0.0." "100." "127.0.0.1" ]; 
        "server smb encrypt" = "required"; # Force encryption over the local wire
      };
    
      "Music" = {
        "path" = "/mnt/media/music"; # Point this to your hard drive music mount
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
      
        # The Security Safety Nets:
        "force group" = "media";      # Any files written over SMB are forced into the media group
        "create mask" = "0664";       # Owner/Group get full Read/Write; Others get Read-Only
        "directory mask" = "0775";    # Allowed traversal permissions for the group
      };
    };
  };

  # Enable Windows Network Discovery daemon so Dennis pops up natively in your file manager sidebar
  services.samba-wsdd.enable = true;


  security.sudo.wheelNeedsPassword = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
  };

  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
