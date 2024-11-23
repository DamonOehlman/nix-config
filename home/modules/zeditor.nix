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
}
