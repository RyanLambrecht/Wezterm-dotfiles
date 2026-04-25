local wezterm = require("wezterm")
local wallpaper = require("random_wallpaper")

local config = wezterm.config_builder()

-- ── Constants

local OPACITY = 0.85
local BLUR = 20

-- ── Window

config.window_padding = { top = 1 }
config.window_decorations = "RESIZE" -- resize border, no title bar
config.window_close_confirmation = "NeverPrompt"
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.max_fps = 120

-- ── Background

local _ = wallpaper.random_wallpaper() -- side-effectful call kept for parity

local function windowed_background()
	return {} -- transparent + blur handled by window_background_opacity
end

local function fullscreen_background()
	return {
		{
			source = { File = "/Users/ryan/.config/wallpapers/1 - beJH98Y.jpg" },
			opacity = 1,
			hsb = { brightness = 0.01 },
		},
		{
			source = {
				Gradient = {
					colors = { "#1a1a1a", "#0f0f0f" },
					orientation = { Linear = { angle = -45.0 } },
				},
			},
			opacity = 1,
		},
	}
end

-- Swap background and blur when toggling fullscreen
wezterm.on("window-resized", function(window, _pane)
	local dims = window:get_dimensions()
	local overrides = window:get_config_overrides() or {}

	if dims.is_full_screen then
		overrides.background = fullscreen_background()
		overrides.window_background_opacity = 1.0
		overrides.macos_window_background_blur = 0
	else
		overrides.background = windowed_background()
		overrides.window_background_opacity = OPACITY
		overrides.macos_window_background_blur = BLUR
	end

	window:set_config_overrides(overrides)
end)

-- Default (windowed) background on launch
config.background = windowed_background()
config.window_background_opacity = OPACITY
config.macos_window_background_blur = BLUR
config.text_background_opacity = 1.0

-- ── Colors

local tab_bg = string.format("rgba(0, 0, 0, %.2f)", OPACITY)

config.colors = {
	tab_bar = {
		background = tab_bg,
		inactive_tab = { bg_color = tab_bg, fg_color = "#808080" },
		inactive_tab_hover = { bg_color = tab_bg, fg_color = "#aaaaaa" },
		active_tab = { bg_color = tab_bg, fg_color = "#ffffff" },
	},
}

-- ── Keybinds

config.keys = {
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentTab({ confirm = false }),
	},
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	{
		key = "LeftArrow",
		mods = "ALT",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "RightArrow",
		mods = "ALT",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "UpArrow",
		mods = "ALT",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "DownArrow",
		mods = "ALT",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "|",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "_",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
}

return config
