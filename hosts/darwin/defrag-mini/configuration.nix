{ userConfig, ... }: {
  # User configuration
  users.users.${userConfig.name} = {
    name = "${userConfig.name}";
    home = "/Volumes/user-${userConfig.name}";
  };

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 5;
}
