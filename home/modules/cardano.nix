{ pkgs, ... }:
{
  # Note: We use a custom Rust-based key generator instead of cardano-cli
  # See: cnft.dev-workers/tools/keygen/
  #
  # To use: cargo build --release --bin cardano-keygen
  #
  # Benefits:
  # - Lightweight (~2MB vs 100MB+ for cardano-node)
  # - Fast key generation
  # - Uses Pallas (same as our signing service)
  # - No GHC/Haskell dependencies

  home.packages = with pkgs; [
    # Utilities for working with Cardano keys
    jq # Parse JSON key files
    xxd # Hex manipulation
  ];
}
