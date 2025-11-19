{ outputs, ... }:
{
  imports = [
    ../modules/alacritty.nix
    ../modules/kitty.nix
    ../modules/atuin.nix
    ../modules/bat.nix
    ../modules/btop.nix
    ../modules/fastfetch.nix
    ../modules/fzf.nix
    ../modules/git.nix
    ../modules/go.nix
    ../modules/gpg.nix
    ../modules/home.nix
    # ../modules/krew.nix
    ../modules/lang-deno.nix
    ../modules/lang-rust.nix
    ../modules/lang-node.nix
    ../modules/lang-bun.nix
    ../modules/lazygit.nix
    ../modules/neovim.nix
    ../modules/saml2aws.nix
    ../modules/scripts.nix
    ../modules/tmux.nix
    ../modules/zsh.nix
    # ../modules/vscode.nix
    ../modules/zeditor.nix
    ../modules/catppuccin.nix

    # ai helpers
    ./claude.nix

    # cardano tooling
    ./cardano.nix
  ];

  # Nixpkgs configuration
  nixpkgs = {
    overlays = [ outputs.overlays.stable-packages ];
    config = {
      allowUnfree = true;
    };
  };
}
