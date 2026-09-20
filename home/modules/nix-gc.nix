{ config, lib, pkgs, ... }:
let
  keep = "30d";

  # home-manager falls back to pkgs.nix when nix.package is unset.
  nixPackage = if config.nix.package != null then config.nix.package else pkgs.nix;
in {
  # nix-collect-garbage only prunes the profiles of the user that runs it, so
  # the system-level nix.gc (running as root) never touches the home-manager
  # generations under ~/.local/state/nix/profiles. This covers those.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    randomizedDelaySec = "45min";
    options = "--delete-older-than ${keep}";
  };

  # On Darwin home-manager passes nix.gc.options through as a *single* argv
  # element, so nix-collect-garbage sees the flag and its value glued together
  # and fails with "unrecognised flag '--delete-older-than 30d'". Rebuild the
  # argument list properly.
  launchd.agents.nix-gc.config.ProgramArguments =
    lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (lib.mkForce [
      "${nixPackage}/bin/nix-collect-garbage"
      "--delete-older-than"
      keep
    ]);
}
