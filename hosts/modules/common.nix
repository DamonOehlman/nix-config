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

    # terminal: alacritty is installed per-user via home-manager
    # (home/modules/alacritty.nix) on both platforms. Deliberately not listed
    # here — a second system-wide copy on macOS would put a duplicate .app in
    # /Applications/Nix Apps alongside the home-manager bundle, and two bundles
    # sharing one bundle ID breaks focus and window management. Linux keeps a
    # system-wide copy for use outside the user session; see common-linux.nix.

    # editors
    # zed-editor  # installed via Homebrew cask for newer versions
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
    # discord  # macOS: installed via Homebrew cask (Nix bundle is read-only,
    #          # which breaks Discord's self-updater). Linux: in common-linux.nix.

  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.zed-mono
    nerd-fonts.meslo-lg
    roboto
  ];

  programs.zsh.enable = true;
}
