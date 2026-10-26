{ pkgs, lib, config, ... }:
let
  sketchybarConfig = ./../../files/configs/sketchybar;
  bordersConfig = ./../../files/configs/borders;
  # nixpkgs is still 2.24.0. 2.24.1 keeps the window stack intact when a
  # bar item is clicked on macOS 27 — otherwise the crust background jumps
  # in front of every item and the bar looks like it crashed.
  sketchybar = pkgs.sketchybar.overrideAttrs (old: rec {
    version = "2.24.1";
    src = pkgs.fetchFromGitHub {
      owner = "FelixKratz";
      repo = "SketchyBar";
      rev = "v${version}";
      hash = "sha256-fEbVzafjFTigR7TjQ41gOnDpk6S4B8qCwpz890ZNgwE=";
    };
  });
  aerospace-scratchpad = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "aerospace-scratchpad";
    version = "0.7.1";
    src = pkgs.fetchurl {
      url = "https://github.com/cristianoliveira/aerospace-scratchpad/releases/download/v${version}/aerospace-scratchpad-v${version}-darwin-arm64.tar.gz";
      sha256 = "e0966c330c41dedfa63c9b0bda91dc71fefc031f60c63c0e07865de4cea60384";
    };
    sourceRoot = ".";
    dontFixup = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      install -m755 aerospace-scratchpad $out/bin/aerospace-scratchpad
      runHook postInstall
    '';
    meta = {
      description = "i3/Sway-style scratchpad for AeroSpace";
      homepage = "https://github.com/cristianoliveira/aerospace-scratchpad";
      platforms = [ "aarch64-darwin" ];
    };
  };
  binPath = lib.concatStringsSep ":" [
    "/opt/homebrew/bin"
    "${config.home.profileDirectory}/bin"
    "${config.home.homeDirectory}/.local/bin"
    "/usr/bin"
    "/bin"
    "/usr/sbin"
    "/sbin"
  ];
in {
  home.packages = [
    sketchybar
    pkgs.jankyborders
    aerospace-scratchpad
  ];

  xdg.configFile."sketchybar" = {
    source = sketchybarConfig;
    recursive = true;
  };

  xdg.configFile."borders" = {
    source = bordersConfig;
    recursive = true;
  };

  launchd.agents.sketchybar = {
    enable = true;
    config = {
      ProgramArguments = [ "${sketchybar}/bin/sketchybar" ];
      KeepAlive = true;
      RunAtLoad = true;
      EnvironmentVariables = {
        LANG = "en_US.UTF-8";
        PATH = binPath;
      };
      StandardOutPath = "/tmp/sketchybar.log";
      StandardErrorPath = "/tmp/sketchybar.err.log";
    };
  };

  launchd.agents.borders = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.jankyborders}/bin/borders"
        "style=round"
        "width=5.0"
        "hidpi=on"
        "active_color=0xff85c1dc"
        "inactive_color=0xff414559"
      ];
      KeepAlive = true;
      RunAtLoad = true;
      EnvironmentVariables = {
        LANG = "en_US.UTF-8";
        PATH = binPath;
      };
      StandardOutPath = "/tmp/borders.log";
      StandardErrorPath = "/tmp/borders.err.log";
    };
  };

  # --reload keeps existing item fonts; KeepAlive relaunches from sketchybarrc.
  home.activation.reloadSketchybar = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    /usr/bin/pkill -x sketchybar >/dev/null 2>&1 || true
  '';
}
