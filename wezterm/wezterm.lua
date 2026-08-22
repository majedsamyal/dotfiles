local wezterm = require "wezterm"

local config = wezterm.config_builder()
local act = wezterm.action
local shell = os.getenv "SHELL" or "/bin/sh"
local is_macos = wezterm.target_triple:find("apple-darwin", 1, true) ~= nil
local is_linux = wezterm.target_triple:find("linux", 1, true) ~= nil
local primary_mod = is_macos and "CMD" or "CTRL|SHIFT"
local workspace_mod = is_macos and "CMD|SHIFT" or "CTRL|SHIFT"
local pane_mod = is_macos and "CMD|SHIFT" or "ALT|SHIFT"
local vertical_split_mod = is_macos and "CMD|SHIFT" or "CTRL|SHIFT|ALT"
local tab_mod = is_macos and "CMD" or "ALT"
local word_mod = is_macos and "OPT" or "ALT"
local link_mod = is_macos and "CMD" or "CTRL"

config.set_environment_variables = {
  COLORTERM = "truecolor",
}
config.term = "xterm-256color"

config.font = wezterm.font {
  family = "Hack Nerd Font Mono",
  weight = "Regular",
}
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
config.check_for_updates = false

if is_macos then
  config.native_macos_fullscreen_mode = true
  config.send_composed_key_when_left_alt_is_pressed = false
  config.send_composed_key_when_right_alt_is_pressed = false
  config.use_dead_keys = false
elseif is_linux then
  config.enable_wayland = os.getenv "WAYLAND_DISPLAY" ~= nil
end

config.window_frame = {
  font = wezterm.font {
    family = "Hack Nerd Font Mono",
    weight = "Regular",
  },
}

config.keys = {
  { key = "Enter", mods = primary_mod, action = act.ToggleFullScreen },
  { key = "p", mods = workspace_mod, action = act.ActivateCommandPalette },
  { key = "s", mods = workspace_mod, action = act.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" } },
  {
    key = "n",
    mods = workspace_mod,
    action = act.PromptInputLine {
      description = "New workspace name",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(act.SwitchToWorkspace { name = line }, pane)
        end
      end),
    },
  },
  { key = "k", mods = primary_mod, action = act.ClearScrollback "ScrollbackAndViewport" },

  { key = "d", mods = primary_mod, action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "d", mods = vertical_split_mod, action = act.SplitVertical { domain = "CurrentPaneDomain" } },
  { key = "w", mods = primary_mod, action = act.CloseCurrentPane { confirm = true } },

  { key = "h", mods = pane_mod, action = act.ActivatePaneDirection "Left" },
  { key = "j", mods = pane_mod, action = act.ActivatePaneDirection "Down" },
  { key = "k", mods = pane_mod, action = act.ActivatePaneDirection "Up" },
  { key = "l", mods = pane_mod, action = act.ActivatePaneDirection "Right" },

  { key = "LeftArrow", mods = word_mod, action = act.SendString "\x1bb" },
  { key = "RightArrow", mods = word_mod, action = act.SendString "\x1bf" },
  { key = "Backspace", mods = word_mod, action = act.SendString "\x17" },

  { key = "=", mods = primary_mod, action = act.IncreaseFontSize },
  { key = "-", mods = primary_mod, action = act.DecreaseFontSize },
  { key = "0", mods = primary_mod, action = act.ResetFontSize },
}

for index = 1, 9 do
  table.insert(config.keys, {
    key = tostring(index),
    mods = tab_mod,
    action = act.ActivateTab(index - 1),
  })
end

config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = link_mod,
    action = act.OpenLinkAtMouseCursor,
  },
}

config.launch_menu = {
  { label = "Neovim", args = { "nvim" } },
  { label = "System Monitor", args = { "top" } },
  { label = "Shell", args = { shell, "-l" } },
}

return config
