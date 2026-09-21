{ ... }: {
  # Catpuccin flavor and accent
  catppuccin = {
    # Global toggle on, but don't auto-enroll every port — keep the
    # explicit per-port enables below (matches pre-autoEnable behavior).
    enable = true;
    autoEnable = false;

    flavor = "frappe";
    accent = "sapphire";

    alacritty.enable = true;
    btop.enable = true;
    delta.enable = true;
    starship.enable = true;
    bat.enable = true;
    tmux = {
      enable = true;
      extraConfig = ''
        set -g @catppuccin_flavor "macchiato"
        set -g @catppuccin_status_background "none"

        # Window label: directory, prefixed by the running command when that
        # command is something other than the shell. So an idle window reads
        # "nix-config" and a busy one reads "ssh infra". #W alone is just the
        # command, which makes every idle tab an indistinguishable "zsh".
        # Home collapses to ~ rather than showing the username.
        #
        # The shell test is an exact match on zsh rather than a *sh glob,
        # because ssh would match that glob and get swallowed.
        set -g @window_label "#{?#{==:#{pane_current_command},zsh},,#{pane_current_command} }#{?#{==:#{pane_current_path},#{HOME}},~,#{b:pane_current_path}}"

        set -g @catppuccin_window_current_number_color "#{@thm_peach}"
        set -g @catppuccin_window_current_text " #{E:@window_label}"
        set -g @catppuccin_window_current_text_color "#{@thm_bg}"
        set -g @catppuccin_window_number_color "#{@thm_blue}"
        set -g @catppuccin_window_text " #{E:@window_label}"
        set -g @catppuccin_window_text_color "#{@thm_surface_0}"
        set -g @catppuccin_status_left_separator "█"

        set -g status-right "#{E:@catppuccin_status_host}#{E:@catppuccin_status_date_time}"
        set -g status-left ""
      '';
    };
  };
}
