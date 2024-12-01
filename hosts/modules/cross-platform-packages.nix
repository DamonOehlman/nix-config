{ pkgs, ... }: {

  # System packages
  environment.systemPackages = with pkgs; [
    # nix
    nil
    nixfmt-classic
    home-manager
    nh

    # languages
    (python3.withPackages (ps: with ps; [ pip virtualenv ]))
    pipenv
    rustup
    deno
    aiken
    needle # uber inversion of control swift framework

    # development general
    gcc
    glib
    gnumake

    # terminal
    kitty

    # editors
    zed-editor
    vscode
    vim

    # cli
    pass
    unzip
    dig
    git
    delta
    jq
    killall
    du-dust
    cmake
    fd
    eza
    ripgrep

    # tuis
    caligula

    # chat
    slack
    discord

    # music
    spotify

    # cloud tooling
    awscli2
    terraform
    terragrunt

    # virtualization
    docker-compose
    kubectl
    lazydocker
  ];
}
