{
  pkgs,
  inputs,
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
    nixfmt-classic
    home-manager
    nh

    # languages
    (python3.withPackages (
      ps: with ps; [
        pip
        virtualenv
      ]
    ))
    pipenv
    rustup
    deno
    nodejs_22
    inputs.aiken.packages.${pkgs.stdenv.hostPlatform.system}.aiken

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
    cmake
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
