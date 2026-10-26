{ pkgs, outputs, userConfig, ... }: {
  # Add nix-homebrew configuration
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "${userConfig.name}";
    autoMigrate = true;
  };

  # Nixpkgs configuration
  nixpkgs = {
    overlays = [ outputs.overlays.stable-packages ];
    config = { allowUnfree = true; };
  };

  # Nix settings
  nix.package = pkgs.nix;

  # Age-based garbage collection of the root/system profiles. This deletes
  # system generations older than 30 days and then collects anything that is
  # no longer reachable. Requires nix.enable (default true).
  nix.gc = {
    automatic = true;
    interval = [{ Weekday = 7; Hour = 3; Minute = 15; }];
    options = "--delete-older-than 30d";
  };

  # Tailscale is the standalone/App Store client on the remaining Macs.
  # defrag-mini, defrag-air and defrag-primary already run the nix-darwin daemon
  # from their host configs. Enabling this here while the App Store client is
  # present gives two tailscaled instances; uncomment only after migrating
  # those hosts.
  # services.tailscale.enable = true;

  # Enable Nix daemon (disabled in latest update)
  # services.nix-daemon.enable = true;

  # Add ability to use TouchID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # System settings
  system = {
    defaults = {
      # -1.0 disables acceleration (1:1 with DPI) and feels slow on a
      # retina display with an MX Master. 2.5 matches the trackpad slider
      # near the top of System Settings → Mouse (max 3.0).
      ".GlobalPreferences" = { "com.apple.mouse.scaling" = 2.5; };
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        ApplePressAndHoldEnabled = false;
        AppleShowAllExtensions = true;
        KeyRepeat = 2;
        "com.apple.trackpad.scaling" = 2.5;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = true;
        PMPrintingExpandedStateForPrint = true;
        # SketchyBar owns the top of the screen. Both keys together are
        # System Settings → Menu Bar → Automatically hide → Always.
        # (_HIHideMenuBar alone is "On Desktop Only" and still shows the
        # native extras on an external display.)
        _HIHideMenuBar = true;
        # ctrl+cmd drag a window from anywhere, not just the titlebar.
        NSWindowShouldDragOnGesture = true;
      };
      # The other half of that pair. `AppleMenuBarVisibleInFullscreen` was a typed
      # option until nix-darwin removed it; setting it through the escape hatch keeps
      # the "Always" behaviour the comment above describes.
      CustomUserPreferences = {
        "NSGlobalDomain" = { AppleMenuBarVisibleInFullscreen = false; };
      };
      # Hide Control Center extras from the menu bar so they don't sit
      # on top of SketchyBar when the native bar flashes on mouse-to-top.
      controlcenter = {
        Sound = false;
        Bluetooth = false;
        AirDrop = false;
        Display = false;
        FocusModes = false;
        NowPlaying = false;
      };
      # Sequoia/Tahoe native tiling fights AeroSpace.
      WindowManager = {
        EnableTilingByEdgeDrag = false;
        EnableTopTilingByEdgeDrag = false;
        EnableTilingOptionAccelerator = false;
        EnableTiledWindowMargins = false;
      };
      LaunchServices = { LSQuarantine = false; };
      trackpad = {
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
        Clicking = true;
      };
      finder = {
        AppleShowAllFiles = true;
        CreateDesktop = false;
        FXDefaultSearchScope = "SCcf";
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = true;
        _FXSortFoldersFirst = true;
      };
      dock = {
        autohide = false;
        expose-animation-duration = 0.15;
        show-recents = false;
        showhidden = true;
        persistent-apps = [ "/Applications/Brave Browser.app" ];
        tilesize = 40;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
      };
      # `location` is set per host: each machine targets a directory that
      # actually exists on it (see hosts/darwin/*/configuration.nix).
      screencapture = {
        type = "png";
        disable-shadow = true;
      };
    };
    keyboard = {
      enableKeyMapping = true;
      # swapLeftCtrlAndFn = true;
      # Remap §± to ~
      userKeyMapping = [{
        HIDKeyboardModifierMappingDst = 30064771125;
        HIDKeyboardModifierMappingSrc = 30064771172;
      }];
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
    colima
    pinentry_mac
    # docker
    # needle # uber ioc framework for ios apps
  ];

  homebrew = {
    enable = true;
    brews = [
      "container"
      "hcloud"
      "hudochenkov/sshpass/sshpass"
    ];
    casks = [
      "aerospace"
      "anki"
      "brave-browser"
      "discord"
      "raycast"
      # "android-platform-tools"
      # "android-studio"
      "gcloud-cli"
      "zed"
      # Font cask (not the formulae) — Homebrew bottles for sketchybar /
      # borders fail to build on macOS 27 without Xcode 27 CLT, so those
      # binaries come from nixpkgs instead.
      "font-sketchybar-app-font"
    ];
    taps = [ "nikitabobko/tap" "hudochenkov/sshpass" ];
    onActivation.cleanup = "check";
  };

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 5;
}
