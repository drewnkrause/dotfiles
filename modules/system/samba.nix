{ ... }:

{
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
}
