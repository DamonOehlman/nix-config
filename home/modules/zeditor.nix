{ ... }: {
  # Let Zed manage its own settings.json to allow project-level settings
  # and runtime configuration changes to work properly

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
