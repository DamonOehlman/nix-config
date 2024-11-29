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
  nix.settings = { experimental-features = "nix-command flakes"; };

  nix.optimise.automatic = true;
  nix.package = pkgs.nix;

  # Enable Nix daemon
  services.nix-daemon.enable = true;

  # Add ability to use TouchID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # System settings
  system = {
    defaults = {
      ".GlobalPreferences" = { "com.apple.mouse.scaling" = -1.0; };
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        ApplePressAndHoldEnabled = false;
        AppleShowAllExtensions = true;
        KeyRepeat = 2;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = true;
        PMPrintingExpandedStateForPrint = true;
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
        persistent-apps = [ "/Applications/Arc.app" ];
        tilesize = 40;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
      };
      screencapture = {
        location = "/Volumes/user-${userConfig.name}/Downloads/temp";
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
    (python3.withPackages (ps: with ps; [ pip virtualenv ]))
    awscli2
    colima
    delta
    docker
    du-dust
    eza
    fd
    jq
    kubectl
    lazydocker
    nh
    caligula
    openconnect
    pipenv
    rustup
    nixd
    nil
    nixfmt-classic
    aiken
    deno
    cmake
    needle # uber inversion of control swift framework
    ripgrep
    telegram-desktop
    terraform
    terragrunt
    home-manager
    pass
    zed-editor
    vscode
    slack
    discord
  ];

  # Zsh configuration
  programs.zsh.enable = true;

  # Fonts configuration
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Meslo" "JetBrainsMono" ]; })
    roboto
  ];

  homebrew = {
    enable = true;
    casks = [
      "aerospace"
      "anki"
      "dozer"
      "raycast"
      "skip"
      "android-platform-tools"
      "android-studio"
      "google-cloud-sdk"
    ];
    taps = [ "nikitabobko/tap" "skiptools/skip" ];
    onActivation.cleanup = "zap";
  };

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 5;
}
