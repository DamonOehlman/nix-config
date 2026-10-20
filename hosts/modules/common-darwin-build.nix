{ pkgs, outputs, ... }: {
  # This host runs Determinate Nix, which owns the daemon and the installation.
  # Let nix-darwin manage everything else; its nix.* options are unavailable.
  nix.enable = false;

  nixpkgs = {
    overlays = [ outputs.overlays.stable-packages ];
    config = { allowUnfree = true; };
  };

  # Build-host tooling only. The compositor's flake devshell supplies Rust,
  # Node, Wrangler and just; this list is what the machine needs to get there.
  environment.systemPackages = with pkgs; [
    git
    gnupg
    pinentry-tty
    gnumake
    jq
    unzip
    rsync
    ripgrep
    fd
    eza
    dust
    tmux
    neovim
    nil
    nixfmt
    home-manager
  ];

  programs.zsh.enable = true;

  system.stateVersion = 5;
}
