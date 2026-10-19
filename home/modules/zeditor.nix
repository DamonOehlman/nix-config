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
      },
      {
        "context": "AgentPanel",
        "bindings": {
          "cmd-alt-]": "agents_sidebar::ToggleThreadSwitcher",
          "cmd-alt-[": ["agents_sidebar::ToggleThreadSwitcher", { "select_last": true }]
        }
      },
      {
        "context": "AcpThread > Editor",
        "bindings": {
          "cmd-alt-]": "agents_sidebar::ToggleThreadSwitcher",
          "cmd-alt-[": ["agents_sidebar::ToggleThreadSwitcher", { "select_last": true }]
        }
      },
      {
        "context": "ThreadsSidebar",
        "bindings": {
          "cmd-alt-]": "agents_sidebar::ToggleThreadSwitcher",
          "cmd-alt-[": ["agents_sidebar::ToggleThreadSwitcher", { "select_last": true }]
        }
      },
      {
        "context": "ThreadsSidebar > Editor",
        "bindings": {
          "cmd-alt-]": "agents_sidebar::ToggleThreadSwitcher",
          "cmd-alt-[": ["agents_sidebar::ToggleThreadSwitcher", { "select_last": true }]
        }
      },
      {
        "context": "ThreadSwitcher",
        "bindings": {
          "cmd-alt-]": "agents_sidebar::ToggleThreadSwitcher",
          "cmd-alt-[": ["agents_sidebar::ToggleThreadSwitcher", { "select_last": true }]
        }
      }
    ]
  '';
}
