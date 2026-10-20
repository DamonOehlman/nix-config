{ userConfig, ... }: {
  # User configuration
  users.users.${userConfig.name} = {
    name = "${userConfig.name}";
    home = "/Volumes/user-${userConfig.name}";
  };

  # Headless access over the tailnet; Tailscale itself is enabled in common-darwin.nix.
  services.openssh.enable = true;

  # Screenshots stay next to the home directory on the external volume.
  system.defaults.screencapture.location = "/Volumes/user-${userConfig.name}/Downloads/temp";

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 5;
}
