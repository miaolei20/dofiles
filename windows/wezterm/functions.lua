local wezterm = require("wezterm")
local action = wezterm.action
local F = {}

-- Check if file exists
function F.file_exists(name)
  local file = io.open(name, "r")
  if file ~= nil then
    io.close(file)
    return true
  else
    return false
  end
end

-- Match the appearance to the system's style
function F.scheme_for_appearance(appearance, dark, light)
  if appearance:find "Dark" then
    return dark
  else
    return light
  end
end

-- Get basename of path
function F.basename(string)
  return string.gsub(string, "(.*[/\\])(.*)", "%2")
end

-- Define window title
function F.tab_title(tab_info)
  local title = tab_info.tab_title
  if title and #title > 0 then
    return title
  end
  title = tab_info.active_pane.title
  title = string.gsub(title, "^Copy mode: ", "")
  return title
end

-- Create a flash on terminal
function F.flash_screen(window, pane, config, colors)
  local overrides = window:get_config_overrides() or {}
  local color_bg = colors.background
  local color_flash = colors.selection_bg
  if config.colors.background then
    color_bg = config.colors.background
  else
    color_bg = colors.background
  end
  overrides.colors = config.colors
  overrides.colors.background = color_flash
  window:set_config_overrides(overrides)
  wezterm.sleep_ms(100)
  overrides.colors.background = color_bg
  window:set_config_overrides(overrides)
end

-- Get value from gsettings
function F.gsettings(key)
  return wezterm.run_child_process({"gsettings", "get", "org.gnome.desktop.interface", key})
end

-- Define gsettings value to config
function F.gsettings_config(config)
  if wezterm.target_triple ~= "x86_64-unknown-linux-gnu" then
    return
  end
  local success, stdout, stderr = F.gsettings("cursor-theme")
  if success then
    config.xcursor_theme = stdout:gsub("'(.+)'\n", "%1")
  end
  local success, stdout, stderr = F.gsettings("cursor-size")
  if success then
    config.xcursor_size = tonumber(stdout)
  end
  config.enable_wayland = true
  if config.enable_wayland and os.getenv("WAYLAND_DISPLAY") then
    local success, stdout, stderr = F.gsettings("text-scaling-factor")
    if success then
      config.font_size = (config.font_size or 10.0) * tonumber(stdout)
    end
  end
end

return F