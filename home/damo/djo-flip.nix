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
  ];

  # Omarchy owns the desktop (Hyprland, Waybar, ...). Home Manager only
  # manages user tooling here; import the desktop modules only after checking
  # that they will not overwrite Omarchy's configuration.
  targets.genericLinux.enable = true;
  systemd.user.startServices = "sd-switch";

  # Enable home-manager
  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
