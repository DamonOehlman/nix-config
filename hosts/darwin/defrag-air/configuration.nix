{ userConfig, ... }: {
  system.primaryUser = "damo";

  # User configuration
  users.users.${userConfig.name} = {
    name = "${userConfig.name}";
    home = "/Users/${userConfig.name}";
  };

  # Nix-managed Tailscale daemon. The App Store client is removed.
  services.tailscale.enable = true;

  # Screenshots to the Desktop; this host's home is on the internal volume.
  system.defaults.screencapture.location = "/Users/${userConfig.name}/Desktop";

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 5;
}
