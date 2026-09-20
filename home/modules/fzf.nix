{...}: {
  # Install fzf via home-manager module
  programs.fzf = {
    enable = true;

    # Atuin owns Ctrl-R. Its integration is sourced after fzf's, so it already
    # won in practice; this just makes it explicit and silences the conflict
    # warning. To hand Ctrl-R back to fzf instead, drop this line and set
    # `flags = ["--disable-ctrl-r"]` in atuin.nix.
    historyWidget.command = "";

    defaultCommand = "find .";
    defaultOptions = [
      "--bind '?:toggle-preview'"
      "--bind 'ctrl-a:select-all'"
      # "--bind 'ctrl-e:execute(echo {+} | xargs -o nvim)'"
      "--bind 'ctrl-y:execute-silent(echo {+} | wl-copy)'"
      "--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'"
      "--height=40%"
      "--info=inline"
      "--layout=reverse"
      "--multi"
      "--preview '([[ -f {}  ]] && (bat --color=always --style=numbers,changes {} || cat {})) || ([[ -d {}  ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'"
      "--preview-window=:hidden"
      "--prompt='~ ' --pointer='▶' --marker='✓'"
    ];
  };
}
