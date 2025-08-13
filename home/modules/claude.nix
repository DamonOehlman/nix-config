{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  home.packages = [ pkgs.claude-code ];
  home.sessionVariables.DISABLE_AUTOUPDATER = "1";
}
