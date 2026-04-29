{ pkgs, ... }: {
  home.packages = with pkgs; [
    cargo
    clippy
    rust-analyzer
    rustc
    rustfmt
  ];

  home.sessionPath = [ "$HOME/.cargo/bin" ];
}
