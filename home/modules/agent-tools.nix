{ inputs, pkgs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  agent-playbook = inputs.agent-playbook.packages.${system};
in
{
  # The read-only inspectors and the browser capture tool, present in every shell. A
  # shell an agent spawns loads no devshell, so a tool that exists only inside one is a
  # tool the agent reaches for a `nix develop` wrapper to get — seconds per read where
  # the binary itself costs milliseconds.
  #
  # `playbook` is deliberately absent. It renders the rules embedded in its own binary,
  # so a stale copy writes a stale managed block without saying so; it reaches a
  # repository through the devshell `defrag-nix` pins.
  home.packages = [
    agent-playbook.agent-tools
    agent-playbook.browser-shot
  ];
}
