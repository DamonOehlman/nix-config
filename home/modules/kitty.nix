{ ... }: {
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    catppuccin.enable = true;
    settings = {
      background_opacity = 0.95;
      enable_audio_bell = false;
    };
  };
}
