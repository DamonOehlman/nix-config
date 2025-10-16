{ ... }: {
  home.sessionPath = [ "$HOME/.npm-global/bin" ];
  programs.zsh.sessionVariables = { PATH = "$HOME/.npm-global/bin:$PATH"; };
}
