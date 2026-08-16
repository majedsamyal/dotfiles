local wezterm = require("wezterm")

local config = wezterm.config_builder()
local act = wezterm.action

local home = wezterm.home_dir
local herdr = home .. "/.local/bin/herdr"
local herdr_file = io.open(herdr, "r")
local herdr_exists = herdr_file ~= nil
if herdr_file then
  herdr_file:close()
end

if herdr_exists then
  config.default_prog = { herdr }
end

config.set_environment_variables = {
  COLORTERM = "truecolor",
  TERM = "wezterm",
}

config.font = wezterm.font_with_fallback({
  { family = "JetBrains Mono", weight = "DemiBold" },
  "Symbols Nerd Font Mono",
  "Hack Nerd Font",
  "MesloLGS NF",
  "Apple Color Emoji",
})
config.font_size = 14.0
config.line_height = 1.08
config.cell_width = 1.0
config.freetype_load_target = "Normal"
config.freetype_render_target = "HorizontalLcd"

config.color_scheme = "Builtin Solarized Dark"
config.colors = {
  background = "#0f1419",
  foreground = "#d5d8da",
  cursor_bg = "#f6c177",
  cursor_fg = "#0f1419",
  cursor_border = "#f6c177",
  selection_bg = "#2e4053",
  selection_fg = "#f4f4f5",
  split = "#334155",
  tab_bar = {
    background = "#0b1117",
    active_tab = {
      bg_color = "#263442",
      fg_color = "#f4f4f5",
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = "#121a22",
      fg_color = "#9aa5b1",
    },
    inactive_tab_hover = {
      bg_color = "#1d2833",
      fg_color = "#d5d8da",
    },
    new_tab = {
      bg_color = "#0b1117",
      fg_color = "#9aa5b1",
    },
    new_tab_hover = {
      bg_color = "#1d2833",
      fg_color = "#f4f4f5",
    },
  },
}

config.window_background_opacity = 0.94
config.macos_window_background_blur = 24
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
config.enable_kitty_keyboard = true
config.enable_wayland = false
config.check_for_updates = false

config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false
config.use_dead_keys = false

config.inactive_pane_hsb = {
  saturation = 0.85,
  brightness = 0.72,
}

config.window_frame = {
  font = wezterm.font({ family = "JetBrains Mono", weight = "Bold" }),
  font_size = 13.0,
  active_titlebar_bg = "#0b1117",
  inactive_titlebar_bg = "#0b1117",
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
  { label = "Zsh Login Shell", args = { "/bin/zsh", "-l" } },
}

if herdr_exists then
  table.insert(config.launch_menu, 1, { label = "Herdr", args = { herdr } })
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local title = tab.active_pane.title
  if title == "" then
    title = "shell"
  end

  local edge_background = "#0b1117"
  local background = "#121a22"
  local foreground = "#9aa5b1"

  if tab.is_active then
    background = "#263442"
    foreground = "#f4f4f5"
  elseif hover then
    background = "#1d2833"
    foreground = "#d5d8da"
  end

  local index = tab.tab_index + 1
  local text = " " .. index .. ": " .. title .. " "

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = background } },
    { Text = " " },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = wezterm.truncate_right(text, max_width - 2) },
    { Background = { Color = edge_background } },
    { Foreground = { Color = background } },
    { Text = " " },
  }
end)

return config
