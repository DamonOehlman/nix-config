{ ... }: {
  # Zsh shell configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ff = "fastfetch";

      # git
      gaa = "git add --all";
      gcam = "git commit --all --message";
      gcl = "git clone";
      gco = "git checkout";
      ggl = "git pull";
      ggp = "git push";

      # kubectl
      k = "kubectl";
      kgno = "kubectl get node";
      kdno = "kubectl describe node";
      kgp = "kubectl get pods";
      kep = "kubectl edit pods";
      kdp = "kubectl describe pods";
      kdelp = "kubectl delete pods";
      kgs = "kubectl get svc";
      kes = "kubectl edit svc";
      kds = "kubectl describe svc";
      kdels = "kubectl delete svc";
      kgi = "kubectl get ingress";
      kei = "kubectl edit ingress";
      kdi = "kubectl describe ingress";
      kdeli = "kubectl delete ingress";
      kgns = "kubectl get namespaces";
      kens = "kubectl edit namespace";
      kdns = "kubectl describe namespace";
      kdelns = "kubectl delete namespace";
      kgd = "kubectl get deployment";
      ked = "kubectl edit deployment";
      kdd = "kubectl describe deployment";
      kdeld = "kubectl delete deployment";
      kgsec = "kubectl get secret";
      kdsec = "kubectl describe secret";
      kdelsec = "kubectl delete secret";

      ld = "lazydocker";
      lg = "lazygit";

      repo = "cd $HOME/code";
      temp = "cd $HOME/tmp";

      v = "nvim";
      vi = "nvim";
      vim = "nvim";

      ls = "eza --icons always"; # default view
      ll = "eza -bhl --icons --group-directories-first"; # long list
      la = "eza -abhl --icons --group-directories-first"; # all list
      lt = "eza --tree --level=2 --icons"; # tree
    };
    initContent = ''
      # kubectl auto-complete. Guarded: kubectl comes from common-heavy.nix,
      # which not every host imports, and an unguarded source printed
      # "command not found: kubectl" on every shell start where it is absent.
      if command -v kubectl >/dev/null 2>&1; then
        source <(kubectl completion zsh)
      fi

      # bindings
      bindkey -v
      bindkey '^A' beginning-of-line
      bindkey '^E' end-of-line
      bindkey '^H' backward-delete-word
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word

      # open commands in $EDITOR with C-e
      # autoload -z edit-command-line
      # zle -N edit-command-line
      # bindkey "^e" edit-command-line

      # SSH_AUTH_SOCK is exported by services.gpg-agent (gpg.nix) via
      # programs.zsh.profileExtra -> ~/.zprofile, which also guards against
      # clobbering a forwarded agent over SSH. Don't set it again here.
      #
      # The launch below is still needed: home-manager's gpg-agent launchd job
      # socket-activates on /private/var/run/..., but gpgconf reports
      # ~/.gnupg/S.gpg-agent, so nothing starts the agent for ssh on login.
      gpgconf --launch gpg-agent
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = "$all";
      palette = "catppuccin_frappe";
      # Vendored from the Catppuccin Starship port (Frappé) so the theme does
      # not pull the Rust-built catppuccin-starship package into the build.
      palettes.catppuccin_frappe = {
        base = "#303446";
        blue = "#8caaee";
        crust = "#232634";
        flamingo = "#eebebe";
        green = "#a6d189";
        lavender = "#babbf1";
        mantle = "#292c3c";
        maroon = "#ea999c";
        mauve = "#ca9ee6";
        overlay0 = "#737994";
        overlay1 = "#838ba7";
        overlay2 = "#949cbb";
        peach = "#ef9f76";
        pink = "#f4b8e4";
        red = "#e78284";
        rosewater = "#f2d5cf";
        sapphire = "#85c1dc";
        sky = "#99d1db";
        subtext0 = "#a5adce";
        subtext1 = "#b5bfe2";
        surface0 = "#414559";
        surface1 = "#51576d";
        surface2 = "#626880";
        teal = "#81c8be";
        text = "#c6d0f5";
        yellow = "#e5c890";
      };
      directory = { style = "bold lavender"; };
      aws = { disabled = true; };
      docker_context = { symbol = " "; };
      golang = {
        disabled = true;
        symbol = " ";
      };
      kubernetes = {
        disabled = true;
        style = "bold pink";
        symbol = "󱃾 ";
        format = "[$symbol$context( ($namespace))]($style)";
        contexts = [{
          context_pattern =
            "arn:aws:eks:(?P<var_region>.*):(?P<var_account>[0-9]{12}):cluster/(?P<var_cluster>.*)";
          context_alias = "$var_cluster";
        }];
      };
      lua = {
        disabled = true;
        symbol = " ";
      };
      package = { symbol = " "; };
      php = {
        disabled = true;
        symbol = " ";
      };
      python = {
        disabled = true;
        symbol = " ";
      };
      terraform = { symbol = " "; };
      right_format = "$kubernetes";
    };
  };
}
