{ pkgs, outputs, ... }: {
  nix.settings = { experimental-features = "nix-command flakes"; };
  nix.optimise.automatic = true;

  nixpkgs = {
    overlays = [ outputs.overlays.stable-packages ];
    config = { allowUnfree = true; };
  };

  # System packages
  environment.systemPackages = with pkgs; [
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
