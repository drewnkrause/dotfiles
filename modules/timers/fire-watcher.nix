{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.fire-danger-watcher;
  
  # This creates a self-contained Python script in the Nix store
  fireScript = pkgs.writers.writePython3Bin "fire-watcher" {
    libraries = [ pkgs.python3Packages.requests ];
  } ''
    import requests
    import os
    import sys

    TOPIC = "${cfg.ntfyTopic}"
    COUNTY = "${cfg.county}"
    STATE_FILE = "/var/lib/fire-danger-watcher/last_state.txt"
    API_URL = ("https://services1.arcgis.com/qQaNyq8h4wNEdlUV/arcgis/rest/"
               "services/FireDangerIndex_Public/FeatureServer/0/query")

    INDEX_MAP = {
        "1": {"name": "Low", "emoji": "🟩", "priority": "low",
              "tag": "green_square"},
        "2": {"name": "Moderate", "emoji": "🟦", "priority": "low",
              "tag": "blue_square"},
        "3": {"name": "High", "emoji": "🟨", "priority": "default",
              "tag": "yellow_square"},
        "4": {"name": "Very High", "emoji": "🟧", "priority": "high",
              "tag": "orange_square"},
        "5": {"name": "Extreme", "emoji": "🟥", "priority": "urgent",
              "tag": "red_square"}
    }


    def get_index():
        params = {
            'where': f"NAME='{COUNTY}'",
            'outFields': 'FireIndex',
            'f': 'pjson'
        }
        try:
            res = requests.get(API_URL, params=params, timeout=15).json()
            if res.get('features'):
                attr = res['features'][0]['attributes']
                return str(attr.get('FireIndex'))
        except Exception as e:
            print(f"API Error: {e}", file=sys.stderr)
        return None


    def notify(index_code):
        default_conf = {
            "name": "Unknown", "emoji": "⚪",
            "priority": "default", "tag": "question"
        }
        conf = INDEX_MAP.get(index_code, default_conf)
        headers = {
            "Title": "Fire Hall Sign Update",
            "Priority": conf["priority"],
            "Tags": f"fire,{conf['tag']}",
            "Icon": "https://img.icons8.com/color/96/fire-extinguisher.png",
            "Click": "https://ndresponse.gov/burn-restrictions-fire-danger-maps"
        }
        payload = (f"{conf['emoji']} Official Fire Danger: "
                   f"{conf['name']} (Index {index_code})")
        requests.post(f"https://ntfy.sh/{TOPIC}",
                      data=payload, headers=headers, timeout=10)


    # Main Logic
    curr = get_index()
    if curr:
        last = ""
        if os.path.exists(STATE_FILE):
            with open(STATE_FILE, "r") as f:
                last = f.read().strip()

        if curr != last:
            notify(curr)
            with open(STATE_FILE, "w") as f:
                f.write(curr)
  '';

in {
  options.services.fire-danger-watcher = {
    enable = mkEnableOption "Cass County fire danger watcher service";
    ntfyTopic = mkOption {
      type = types.str;
      description = "The ntfy topic to publish to.";
    };
    county = mkOption {
      type = types.str;
      default = "Cass";
      description = "The ND county to monitor.";
    };
  };

  config = mkIf cfg.enable {
    # Create the state directory on Dennis so the script can write to it
    systemd.tmpfiles.rules = [
      "d /var/lib/fire-danger-watcher 0750 drew users -"
    ];

    systemd.services.fire-danger-watcher = {
      description = "Fire Danger Watcher for Dad";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${fireScript}/bin/fire-watcher";
        User = "drew";
      };
    };

    systemd.timers.fire-danger-watcher = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        # Format: "DayOfWeek Year-Month-Day Hour:Minute:Second"
        # "*-*-* 07:00:00" means every day at 7:00 AM
        OnCalendar = "*-*-* 07:00:00"; 
        Unit = "fire-danger-watcher.service";
        Persistent = true; # Ensures it runs even if Dennis was powered off at 7 AM
      };
    };
  };
}
