local wezterm = require("wezterm")

local M = {}

-- Path to your wallpaper directory
local wallpaper_dir = "/Users/ryan/.config/wallpapers"

-- Collect image files from directory
local function get_wallpapers(dir)
	local wallpapers = {}
	for _, file in ipairs(wezterm.read_dir(dir)) do
		if file:match("%.png$") or file:match("%.jpg$") or file:match("%.jpeg$") then
			table.insert(wallpapers, file)
		end
	end
	return wallpapers
end

-- Return one random wallpaper
function M.random_wallpaper()
	local wallpapers = get_wallpapers(wallpaper_dir)
	if #wallpapers == 0 then
		wezterm.log_error("No wallpapers found in " .. wallpaper_dir)
		return nil
	end

	-- ✅ Safe integer seed for macOS / Lua 5.4
	math.randomseed(os.time() + math.floor(os.clock() * 1000))

	local choice = wallpapers[math.random(#wallpapers)]
	wezterm.log_info("Using wallpaper: " .. choice)
	return choice
end

return M
