{...}: {
  imports = [
    ../modules/go.nix
  ];

  # Enable home-manager
  programs.home-manager.enable = true;

  home.username = "alexander.nabokikh";
  home.homeDirectory = "/Users/alexander.nabokikh";

  # Catpuccin flavor and accent
  # catppuccin = {
  #   flavor = "macchiato";
  #   accent = "lavender";
  # };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
