{ userConfig, ... }:
{
  # Install git via home-manager module
  programs.git = {
    enable = true;
    signing = {
      key = userConfig.gitKey;
      signByDefault = true;
    };
    settings = {
      user = {
        name = userConfig.fullName;
        email = userConfig.email;
      };
      pull.rebase = "true";
    };
  };

  # Delta configuration (now separate from git)
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      keep-plus-minus-markers = true;
      light = false;
      line-numbers = true;
      navigate = true;
      width = 280;
    };
  };
}
