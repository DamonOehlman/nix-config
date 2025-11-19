{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Cardano CLI for key generation and transaction building
    cardano-cli

    # Optional: cardano-node if you want to run a local node
    # cardano-node

    # Optional: cardano-wallet for wallet functionality
    # cardano-wallet
  ];

  # Add cardano-cli to path
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # Optional: Set up cardano network configuration
  home.file.".cardano/mainnet-config.json" = {
    enable = false; # Set to true if you want to download mainnet configs
    text = ''
      {
        "NetworkMagic": 764824073
      }
    '';
  };
}
