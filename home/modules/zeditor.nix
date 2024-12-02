{ ... }: {
  home.file.".config/zed/settings.json".text = ''
    {
      "ui_font_size": 14,
      "buffer_font_size": 12,
      "theme": {
        "mode": "system",
        "light": "One Light",
        "dark": "Catppuccin Frappé"
      },
      "languages": {
        "Nix": {
          "formatter": {
            "external": {
              "command": "nixfmt"
            }
          }
        }
      }
    }
  '';

  home.file.".config/zed/keymap.json".text = ''
    [
      {
        "context": "Editor",
        "bindings": {
          "ctrl-a": "editor::MoveToBeginningOfLine",
          "ctrl-e": "editor::MoveToEndOfLine",
          "ctrl-shift-a": "editor::SelectAll"
        }
      }
    ]
  '';
}
