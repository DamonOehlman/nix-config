{ ... }:
{
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    catppuccin.enable = true;
    settings = {
      backgroundOpacity = 0.9;
    };
  };
}
