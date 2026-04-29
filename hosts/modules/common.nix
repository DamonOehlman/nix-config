{
  pkgs,
  outputs,
  ...
}:
{
  nix.settings = {
    experimental-features = "nix-command flakes";
  };
  nix.optimise.automatic = true;

  nixpkgs = {
    overlays = [ outputs.overlays.stable-packages ];
    config = {
      allowUnfree = true;
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # nix
    nil
    nixfmt
    home-manager
    nh

    # development general
    gnumake

    # terminal
    kitty

    # editors
    zed-editor
    # vscode
    vim

    # cli
    pass
    unzip
    dig
    git
    delta
    jq
    killall
    dust
    fd
    eza
    ripgrep
    cloudflared

    # tuis
    caligula

    # chat
    slack
    discord

  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.zed-mono
    nerd-fonts.meslo-lg
    roboto
  ];

  programs.zsh.enable = true;
}
