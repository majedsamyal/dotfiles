local wezterm = require("wezterm")

local config = wezterm.config_builder()
local act = wezterm.action
local shell = os.getenv("SHELL") or "/bin/sh"

config.set_environment_variables = {
  COLORTERM = "truecolor",
  TERM = "wezterm",
}

config.font = wezterm.font({
  family = "Hack Nerd Font",
  weight = "Regular",
})
config.font_size = 16.0

config.color_scheme = "Catppuccin Mocha"
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 14,
  right = 14,
  top = 12,
  bottom = 10,
}
config.initial_cols = 132
config.initial_rows = 38
config.adjust_window_size_when_changing_font_size = false
config.native_macos_fullscreen_mode = true
config.window_close_confirmation = "AlwaysPrompt"

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false
config.tab_max_width = 28
config.show_new_tab_button_in_tab_bar = true
config.show_tab_index_in_tab_bar = true
config.switch_to_last_active_tab_when_closing_tab = true

config.audible_bell = "Disabled"
config.scrollback_lines = 20000
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 650
config.enable_scroll_bar = false
-- Some terminal apps handle the Kitty keyboard protocol poorly and make Esc
-- feel delayed, so keep the simpler keyboard path.
config.enable_kitty_keyboard = false
config.enable_wayland = false
config.check_for_updates = false

config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false
config.use_dead_keys = false

config.window_frame = {
  font = wezterm.font({
    family = "Hack Nerd Font",
    weight = "Regular",
  }),
}

config.keys = {
  { key = "Enter", mods = "CMD", action = act.ToggleFullScreen },
  { key = "p", mods = "CMD|SHIFT", action = act.ActivateCommandPalette },
  { key = "s", mods = "CMD|SHIFT", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
  {
    key = "n",
    mods = "CMD|SHIFT",
    action = act.PromptInputLine({
      description = "New workspace name",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
        end
      end),
    }),
  },
  { key = "k", mods = "CMD", action = act.ClearScrollback("ScrollbackAndViewport") },

  { key = "d", mods = "CMD", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "d", mods = "CMD|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "w", mods = "CMD", action = act.CloseCurrentPane({ confirm = true }) },

  { key = "h", mods = "CMD|SHIFT", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "CMD|SHIFT", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "CMD|SHIFT", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "CMD|SHIFT", action = act.ActivatePaneDirection("Right") },

  { key = "LeftArrow", mods = "OPT", action = act.SendString("\x1bb") },
  { key = "RightArrow", mods = "OPT", action = act.SendString("\x1bf") },
  { key = "Backspace", mods = "OPT", action = act.SendString("\x17") },

  { key = "=", mods = "CMD", action = act.IncreaseFontSize },
  { key = "-", mods = "CMD", action = act.DecreaseFontSize },
  { key = "0", mods = "CMD", action = act.ResetFontSize },
}

for index = 1, 9 do
  table.insert(config.keys, {
    key = tostring(index),
    mods = "CMD",
    action = act.ActivateTab(index - 1),
  })
end

config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CMD",
    action = act.OpenLinkAtMouseCursor,
  },
}

config.launch_menu = {
  { label = "Neovim", args = { "nvim" } },
  { label = "System Monitor", args = { "top" } },
  { label = "Shell", args = { shell, "-l" } },
}

return config
