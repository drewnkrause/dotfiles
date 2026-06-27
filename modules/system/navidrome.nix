{ config, pkgs, lib, ... }:

let
  # 1. Fetch and drop the asset precisely into share/plugins/ as the module expects
  navidrome-lyrics-plugin = pkgs.stdenv.mkDerivation rec {
    pname = "navidrome-lyrics-plugin";
    version = "6.1.3";

    src = pkgs.fetchurl {
      url = "https://github.com/J0R6IT0/navidrome-lyrics-plugin/releases/download/v${version}/nd-lyrics.ndp";
      sha256 = "sha256-U54KfULuMBDkJYzn4nuV8oKdaqJU20MMhnDv43rB9dY="; 
    };

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/share/plugins
      cp $src $out/share/plugins/nd-lyrics.ndp
    '';
  };

  # 2. Use symlinkJoin to cleanly merge paths without messing up globbing,
  # then attach the necessary meta attributes and dummy override function.
  wrappedNavidrome = let
    baseJoined = pkgs.symlinkJoin {
      name = "navidrome"; # Keeping the name "navidrome" matches the binary name for getExe
      paths = [
        pkgs.navidrome
        navidrome-lyrics-plugin
      ];
    };
  in baseJoined // { 
    override = _: wrappedNavidrome;
    meta = pkgs.navidrome.meta // { mainProgram = "navidrome"; };
  };
in
{
  sops.secrets.navidrome_env = {};

  users.users.navidrome.extraGroups = [ "media" ];

  environment.systemPackages = [ pkgs.ffmpeg-full ];
  
  services.navidrome = {
    enable = true;
    environmentFile = config.sops.secrets.navidrome_env.path;

    package = wrappedNavidrome;
    plugins = []; # Keep empty to bypass source compilation
    
    settings = {
      Address = "0.0.0.0";
      Port = 4533;
      MusicFolder = "/mnt/media/music";

      LyricsPriority = "nd-lyrics,.lrc,.txt,embedded";
            
      ScanInterval = "1m"; 
      SessionTimeout = "24h";
    };
  };
}
