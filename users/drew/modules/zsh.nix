{ config, pkgs, lib, ... }: # Note: Added 'lib' here

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 1000;
      save = 1000;
      path = "$HOME/.zsh_history";
    };

    zplug = {
      enable = true;
      plugins = [
        { name = "romkatv/powerlevel10k"; tags = [ "as:theme" "depth:1" ]; }
        { name = "zsh-users/zsh-completions"; }
        { name = "Aloxaf/fzf-tab"; }
        
        # Fixed: 'from' must be inside 'tags'
        { name = "plugins/git"; tags = [ "from:oh-my-zsh" ]; }
        { name = "plugins/sudo"; tags = [ "from:oh-my-zsh" ]; }
        { name = "plugins/aws"; tags = [ "from:oh-my-zsh" ]; }
        { name = "plugins/kubectl"; tags = [ "from:oh-my-zsh" ]; }
        { name = "plugins/kubectx"; tags = [ "from:oh-my-zsh" ]; }
        { name = "plugins/command-not-found"; tags = [ "from:oh-my-zsh" ]; }
        { name = "plugins/eza"; tags = [ "from:oh-my-zsh" ]; }
      ];
    };

    # The new consolidated way to handle .zshrc content
    initContent = lib.mkMerge [
      # lib.mkBefore ensures this is at the absolute top for p10k
      (lib.mkBefore ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')

      # This is the "standard" body of your .zshrc
      ''
        # Completion styling
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color -a $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color -a $realpath'

        bindkey -e

        # Load p10k config if it exists
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      ''
    ];

    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ~/dotfiles";
      nrt = "sudo nixos-rebuild test --flake ~/dotfiles#laptop"; # Test without committing to boot menu
      dots = "$EDITOR ~/dotfiles";
    };
  };

  # Rest of the config remains the same
  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd"
    ];
  };

  home.packages = with pkgs; [
    eza
    bat
  ];
}
