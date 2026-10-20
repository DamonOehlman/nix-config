{ userConfig, ... }: {
  # User configuration
  users.users.${userConfig.name} = {
    name = "${userConfig.name}";
    home = "/Users/${userConfig.name}";
  };

  # Screenshots to the Desktop; this host's home is on the internal volume.
  system.defaults.screencapture.location = "/Users/${userConfig.name}/Desktop";

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 5;
}
