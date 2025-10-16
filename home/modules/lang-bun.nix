{ ... }: {
  home.sessionPath = [ "$HOME/.bun/bin" ];

  programs.zsh.sessionVariables = { PATH = "$HOME/.bun/bin:$PATH"; };
}
