{ ... }: {
  imports = [
    ../modules/home.nix
    ../modules/zsh.nix
    ../modules/git.nix
    ../modules/gpg.nix
    ../modules/direnv.nix
    ../modules/tmux.nix
    ../modules/btop.nix
    ../modules/fzf.nix
    ../modules/lazygit.nix
    ../modules/agent-tools.nix
  ];

  # Enable home-manager
  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
