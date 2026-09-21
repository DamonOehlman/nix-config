{ pkgs, lib, ... }:
let
  # TOML escape for tmux's prefix key, C-b (byte 0x02).
  #
  # Assembled from a Nix-escaped backslash rather than written literally: we
  # need a backslash-u escape to reach the TOML file so alacritty's parser
  # decodes it, and a raw control byte in the source is both fragile to edit
  # and invalid inside a TOML basic string.
  ctrlB = "\\" + "u0002";

  # Keybindings are hand-written TOML rather than going through
  # programs.alacritty.settings, because home-manager's TOML generator cannot
  # express the above: it emits values as TOML *literal* strings ('...'), where
  # escapes are not interpreted, and a raw control byte breaks its JSON
  # round-trip outright.
  #
  # Every binding lives here, not just the tmux ones. Alacritty loads the
  # importing file last and replaces any field that file also defines, so
  # leaving keyboard.bindings in settings would silently override all of this.
  keybindings = pkgs.writeText "alacritty-keybindings.toml" ''
    [[keyboard.bindings]]
    key = "C"
    mods = "Control|Shift"
    action = "Copy"

    [[keyboard.bindings]]
    key = "V"
    mods = "Control|Shift"
    action = "Paste"

    # kitty-style tabs. Alacritty has none of its own, but every window here is
    # a tmux session (see terminal.shell), so these send the matching tmux
    # sequence: C-b c / C-b n / C-b p. The usual C-b bindings still work.
    [[keyboard.bindings]]
    key = "T"
    mods = "Command"
    chars = "${ctrlB}c"

    [[keyboard.bindings]]
    key = "]"
    mods = "Command"
    chars = "${ctrlB}n"

    [[keyboard.bindings]]
    key = "["
    mods = "Command"
    chars = "${ctrlB}p"

    # Jump to tab N. Ctrl+Shift rather than Cmd because AeroSpace binds
    # cmd-1..9 to workspace switching and grabs them before alacritty sees
    # them. tmux baseIndex is 1, so these line up with the numbers on screen.
    ${lib.concatMapStrings
      (n: ''
        [[keyboard.bindings]]
        key = "${toString n}"
        mods = "Control|Shift"
        chars = "${ctrlB}${toString n}"

      '')
      (lib.range 1 9)}
  '';
in {
  # Install alacritty via home-manager module
  programs.alacritty = {
    enable = true;
    settings = {
      general.import = [ "${keybindings}" ];

      terminal.shell = {
        program = "zsh";
        args = [ "-l" "-c" "tmux" ];
      };

      env = { TERM = "xterm-256color"; };

      # Keyboard-driven link opening — the alacritty equivalent of kitty's
      # hints kitten. Ctrl+Shift+U labels every URL on screen; press the label
      # to open it. Also makes URLs clickable without holding a modifier.
      hints = {
        alphabet = "jfkdls;ahgurieowpq";
        enabled = [
          {
            regex = "(https?://|mailto:|file://|git://|ssh://|ftp://)[^\\s\"'()\\[\\]<>]+";
            hyperlinks = true;
            post_processing = true;
            persist = false;
            command = if pkgs.stdenv.hostPlatform.isDarwin then "open" else "xdg-open";
            binding = {
              key = "U";
              mods = "Control|Shift";
            };
            mouse = {
              enabled = true;
              mods = "None";
            };
          }
        ];
      };

      window = {
        decorations = if pkgs.stdenv.hostPlatform.isDarwin then "buttonless" else "none";
        dynamic_title = false;
        dynamic_padding = true;
        dimensions = {
          columns = 170;
          lines = 45;
        };
        padding = {
          x = 5;
          y = 1;
        };
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      font = {
        size = if pkgs.stdenv.hostPlatform.isDarwin then 15 else 12;
        normal = {
          family = "MesloLGS Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "MesloLGS Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "MesloLGS Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "MesloLGS Nerd Font";
          style = "Italic";
        };
      };

      selection = {
        semantic_escape_chars = '',│`|:"' ()[]{}<>'';
        save_to_clipboard = true;
      };
    };
  };
}
