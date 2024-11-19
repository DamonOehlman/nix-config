{
  pkgs,
  userConfig,
  homeDirectory,
  ...
}: {
  # Home-Manager configuration for the user's home environment
  home = {
    username = "${userConfig.name}";
    homeDirectory = homeDirectory;
  };
}
