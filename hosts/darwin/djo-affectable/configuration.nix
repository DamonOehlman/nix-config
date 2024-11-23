{
  pkgs,
  outputs,
  userConfig,
  ...
}: {
  # User configuration
  users.users.${userConfig.name} = {
    name = "${userConfig.name}";
    home = "/Users/${userConfig.name}";
  };

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 5;
}
