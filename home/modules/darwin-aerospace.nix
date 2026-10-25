{ pkgs, lib, config, ... }: {
  imports = [ ./darwin-sketchybar.nix ];

  # Source aerospace config from the home-manager store
  home.file.".aerospace.toml".text = ''
    config-version = 2

    after-login-command = []

    # You can use it to add commands that run after AeroSpace startup.
    # 'after-startup-command' is run after 'after-login-command'
    # Available commands : https://nikitabobko.github.io/AeroSpace/commands
    # SketchyBar and JankyBorders also have launchd agents; both detect an
    # already-running process so a double start is a no-op.
    after-startup-command = [
        'exec-and-forget sketchybar',
        'exec-and-forget borders',
    ]

    exec-on-workspace-change = [
        '/bin/bash',
        '-c',
        'sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$AEROSPACE_FOCUSED_WORKSPACE"; aerospace-scratchpad hook pull-window "$AEROSPACE_PREV_WORKSPACE" "$AEROSPACE_FOCUSED_WORKSPACE" || true',
    ]

    # launchd (below) starts AeroSpace. If this is true the app also
    # registers its own login item after the first launch, and the two fight.
    start-at-login = false

    # Automatically reload the config when it changes. home-manager swaps
    # ~/.aerospace.toml for a new store symlink on every switch, so without
    # this the running instance would keep the config it loaded at startup.
    # After enabling, reload once manually to start the auto-reloading.
    auto-reload-config = true

    # Normalizations. See: https://nikitabobko.github.io/AeroSpace/guide#normalization
    enable-normalization-flatten-containers = true
    enable-normalization-opposite-orientation-for-nested-containers = true

    # See: https://nikitabobko.github.io/AeroSpace/guide#layouts
    # The 'accordion-padding' specifies the size of accordion padding
    # You can set 0 to disable the padding feature
    accordion-padding = 30

    # Possible values: tiles|accordion
    default-root-container-layout = 'tiles'

    # Possible values: horizontal|vertical|auto
    # 'auto' means: wide monitor (anything wider than high) gets horizontal orientation,
    #               tall monitor (anything higher than wide) gets vertical orientation
    default-root-container-orientation = 'auto'

    # Mouse follows focus when focused monitor changes
    # Drop it from your config, if you don't like this behavior
    # See https://nikitabobko.github.io/AeroSpace/guide#on-focus-changed-callbacks
    # See https://nikitabobko.github.io/AeroSpace/commands#move-mouse
    # Fallback value (if you omit the key): on-focused-monitor-changed = []
    on-focused-monitor-changed = ['move-mouse monitor-lazy-center']
    on-focus-changed = ['exec-and-forget sketchybar --trigger aerospace_focus_change']
    on-mode-changed = ['exec-and-forget sketchybar --trigger aerospace_mode_change']

    # You can effectively turn off macOS "Hide application" (cmd-h) feature by toggling this flag
    # Useful if you don't use this macOS feature, but accidentally hit cmd-h or cmd-alt-h key
    # Also see: https://nikitabobko.github.io/AeroSpace/goodness#disable-hide-app
    automatically-unhide-macos-hidden-apps = false

    # Keep 1-9 alive so SketchyBar always has a slot, even when empty.
    # Scratchpad workspaces (`.scratchpad`) are managed by aerospace-scratchpad.
    persistent-workspaces = ['1', '2', '3', '4', '5', '6', '7', '8', '9']

    # Possible values: (qwerty|dvorak)
    # See https://nikitabobko.github.io/AeroSpace/guide#key-mapping
    [key-mapping]
    preset = 'qwerty'

    # launchd AeroSpace has a minimal PATH; exec-and-forget and the
    # workspace-change hook need Homebrew plus ~/.local/bin wrappers.
    [exec]
    inherit-env-vars = true

    [exec.env-vars]
    PATH = '/opt/homebrew/bin:${config.home.profileDirectory}/bin:${config.home.homeDirectory}/.local/bin:/usr/bin:/bin:/usr/sbin:/sbin'

    # Gaps between windows (inner-*) and between monitor edges (outer-*).
    # Possible values:
    # - Constant:     gaps.outer.top = 8
    # - Per monitor:  gaps.outer.top = [{ monitor.main = 16 }, { monitor."some-pattern" = 32 }, 24]
    #                 In this example, 24 is a default value when there is no match.
    #                 Monitor pattern is the same as for 'workspace-to-monitor-force-assignment'.
    #                 See: https://nikitabobko.github.io/AeroSpace/guide#assign-workspaces-to-monitors
    [gaps]
    inner.horizontal = 8
    inner.vertical = 8
    outer.left = 4
    outer.bottom = 4
    # Native menu bar still insets ~30px even when SketchyBar covers it
    # (topmost=on). 8px on top of that is a small gap under the bar.
    outer.top = 8
    outer.right = 4

    # 'main' binding mode declaration
    # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
    # 'main' binding mode must be always presented
    # Fallback value (if you omit the key): mode.main.binding = {}
    [mode.main.binding]

    # All possible keys:
    # - Letters.        a, b, c, ..., z
    # - Numbers.        0, 1, 2, ..., 9
    # - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
    # - F-keys.         f1, f2, ..., f20
    # - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon, backtick,
    #                   leftSquareBracket, rightSquareBracket, space, enter, esc, backspace, tab
    # - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
    #                   keypadMinus, keypadMultiply, keypadPlus
    # - Arrows.         left, down, up, right

    # All possible modifiers: cmd, alt, ctrl, shift

    # All possible commands: https://nikitabobko.github.io/AeroSpace/commands

    # See: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget
    # Launch through the .app bundle, not $out/bin/alacritty. The bin/ copy
    # lives outside the bundle, so macOS gives the process no bundle identity
    # and AeroSpace reports it as NULL-APP-BUNDLE-ID — the on-window-detected
    # rule below would never match it.
    cmd-alt-enter = 'exec-and-forget open -na ${pkgs.alacritty}/Applications/Alacritty.app'

    # Scratchpad: send focused window, cycle/show next, hide all floating.
    cmd-enter = 'exec-and-forget aerospace-scratchpad-next'
    cmd-shift-enter = 'exec-and-forget aerospace-scratchpad-send'
    cmd-shift-minus = 'exec-and-forget aerospace-scratchpad-hide'

    # Disable macOS hide-app; it orphans windows from the tiling tree.
    cmd-h = []
    cmd-alt-h = []

    # See: https://nikitabobko.github.io/AeroSpace/commands#layout
    alt-slash = 'layout tiles horizontal vertical'
    alt-comma = 'layout accordion horizontal vertical'
    alt-f = 'fullscreen'

    # See: https://nikitabobko.github.io/AeroSpace/commands#focus
    cmd-left = 'focus --boundaries-action wrap-around-the-workspace left'
    cmd-down = 'focus --boundaries-action wrap-around-the-workspace down'
    cmd-up = 'focus --boundaries-action wrap-around-the-workspace up'
    cmd-right = 'focus --boundaries-action wrap-around-the-workspace right'

    # See: https://nikitabobko.github.io/AeroSpace/commands#move
    alt-shift-h = 'move left'
    alt-shift-j = 'move down'
    alt-shift-k = 'move up'
    alt-shift-l = 'move right'

    # See: https://nikitabobko.github.io/AeroSpace/commands#resize
    alt-shift-minus = 'resize smart -50'
    alt-shift-equal = 'resize smart +50'

    # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
    cmd-1 = 'workspace 1'
    cmd-2 = 'workspace 2'
    cmd-3 = 'workspace 3'
    cmd-4 = 'workspace 4'
    cmd-5 = 'workspace 5'
    cmd-6 = 'workspace 6'
    cmd-7 = 'workspace 7'
    cmd-8 = 'workspace 8'
    cmd-9 = 'workspace 9'

    # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
    cmd-shift-1 = 'move-node-to-workspace 1'
    cmd-shift-2 = 'move-node-to-workspace 2'
    cmd-shift-3 = 'move-node-to-workspace 3'
    cmd-shift-4 = 'move-node-to-workspace 4'
    cmd-shift-5 = 'move-node-to-workspace 5'
    cmd-shift-6 = 'move-node-to-workspace 6'
    cmd-shift-7 = 'move-node-to-workspace 7'
    cmd-shift-8 = 'move-node-to-workspace 8'
    cmd-shift-9 = 'move-node-to-workspace 9'

    # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
    alt-tab = 'workspace-back-and-forth'
    # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
    alt-shift-tab = 'move-workspace-to-monitor --wrap-around next'

    # See: https://nikitabobko.github.io/AeroSpace/commands#mode
    alt-shift-semicolon = 'mode service'

    # 'service' binding mode declaration.
    # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
    [mode.service.binding]
    esc = ['reload-config', 'mode main']
    r = ['flatten-workspace-tree', 'mode main'] # reset layout
    f = [
        'layout floating tiling',
        'mode main',
    ] # Toggle between floating and tiling layout
    backspace = ['close-all-windows-but-current', 'mode main']

    # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
    #s = ['layout sticky tiling', 'mode main']

    alt-shift-h = ['join-with left', 'mode main']
    alt-shift-j = ['join-with down', 'mode main']
    alt-shift-k = ['join-with up', 'mode main']
    alt-shift-l = ['join-with right', 'mode main']

    [[on-window-detected]]
    if.app-id = 'company.thebrowser.Browser'
    run = ['move-node-to-workspace 3']

    # Primary Brave profile lands on 4. A second profile window is moved to 3
    # with cmd-shift-3 — Chromium titles are often unset when this callback
    # fires, so a title regex cannot tell the profiles apart reliably.
    [[on-window-detected]]
    if.app-id = 'com.brave.Browser'
    run = ['move-node-to-workspace 4']

    [[on-window-detected]]
    if.app-id = 'com.microsoft.VSCode'
    run = ['move-node-to-workspace 2']

    [[on-window-detected]]
    if.app-id = 'org.alacritty'
    run = ['move-node-to-workspace 1']

    [[on-window-detected]]
    if.app-id = 'com.tinyspeck.slackmacgap'
    run = ['move-node-to-workspace 8']

    [[on-window-detected]]
    if.app-id = 'com.hnc.Discord'
    run = ['move-node-to-workspace 9']

    [[on-window-detected]]
    if.app-id = 'com.obsproject.obs-studio'
    run = 'move-node-to-workspace 4'

    [[on-window-detected]]
    if.app-id = 'com.apple.iphonesimulator'
    run = ['layout floating']

    # A capture still opens a window, and the kit marks it while it runs:
    # `Args::window_title` appends "[capture]" for --shot/--sheet/--sprites/
    # --plan. Park only an unbundled binary carrying that marker, so a
    # one-second window cannot retile the focused workspace while an
    # interactive run, or a normal app with "[capture]" in a filename, stays.
    [[on-window-detected]]
    if = 'test %{window-title} ~= \[capture\] && test %{app-bundle-id} = NULL-APP-BUNDLE-ID'
    run = ['layout floating', 'exec-and-forget aerospace-park-capture "$AEROSPACE_WINDOW_ID"']
  '';

  # Homebrew installs the .app at a stable /Applications path, which is what
  # macOS Accessibility TCC is keyed on. start-at-login in the toml only
  # writes a login item after the app has been launched once — it never was
  # on this machine, so the server was simply not running.
  launchd.agents.aerospace = {
    enable = true;
    config = {
      ProgramArguments = [ "/Applications/AeroSpace.app/Contents/MacOS/AeroSpace" ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/tmp/aerospace.log";
      StandardErrorPath = "/tmp/aerospace.err.log";
    };
  };

  # Gatekeeper rejects the Homebrew-cask copy while quarantine xattrs remain
  # (spctl --assess: rejected). Strip them on every switch; cask upgrades
  # put them back.
  home.activation.clearAerospaceQuarantine =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -d /Applications/AeroSpace.app ]; then
        # FinderInfo leftover from migration/Time Machine makes codesign
        # --verify fail with "resource fork, Finder information, or similar
        # detritus not allowed" and Gatekeeper report the bundle as rejected.
        /usr/bin/xattr -cr /Applications/AeroSpace.app 2>/dev/null || true
      fi
    '';
}
