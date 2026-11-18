-- Hyprland configuration (Lua) — https://wiki.hypr.land/Configuring/Start/

-- DMS_STARTUP_BEGIN
hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd --all")
	hl.exec_cmd("systemctl --user start hyprland-session.target")
end)
-- DMS_STARTUP_END

-- Env vars
-- hl.env("XCURSOR_SIZE", "16")
-- hl.env("HYPRCURSOR_SIZE", "16")
-- hl.env("ELECTRON_OZONE_PLATFORM_HINT","auto")
-- hl.env("QT_QPA_PLATFORMTHEME","gtk3")
-- hl.env("QT_QPA_PLATFORMTHEME_QT6","gtk3")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("GDK_BACKEND", "wayland,x11,*")
-- hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")



hl.config({
	input = {
		-- empty inherits XKB_DEFAULT_LAYOUT (libxkbcommon), falls back to "us"
		kb_layout = "us",
		numlock_by_default = true,
		follow_mouse = 1,
		-- dms/input.lua is required later and wins per key
		touchpad = {
			tap_to_click = true,
			natural_scroll = true,
		},
	},
	general = {
		gaps_in = 2,
		gaps_out = 2,
		border_size = 2,
		layout = "dwindle",
	},
	decoration = {
		rounding = 0,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		-- shadow = {
		-- 	enabled = true,
		-- 	range = 30,
		-- 	render_power = 4,
		-- 	offset = "0 5",
		-- 	color = "rgba(00000070)",
		-- },
	},
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
	},
	dwindle = {
		preserve_split = true,
	},
    master = {
        mfact = 0.5,
    },
    -- xwayland = { force_zero_scaling = true },

})

hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 3, bezier = "default" })

hl.window_rule({ match = { class = "^(org\\.wezfurlong\\.wezterm)$" }, tile = true })
hl.window_rule({ match = { class = "^(org\\.gnome\\.)" }, rounding = 12 })
hl.window_rule({ match = { class = "^(gnome-control-center)$" }, tile = true })
hl.window_rule({ match = { class = "^(pavucontrol)$" }, tile = true })
hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, tile = true })
hl.window_rule({ match = { class = "^(org\\.gnome\\.Calculator)$" }, float = true })
hl.window_rule({ match = { class = "^(gnome-calculator)$" }, float = true })
hl.window_rule({ match = { class = "^(galculator)$" }, float = true })
hl.window_rule({ match = { class = "^(blueman-manager)$" }, float = true })
hl.window_rule({ match = { class = "^(xdg-desktop-portal)$" }, float = true })
hl.window_rule({
	match = { class = "^(steam)$", title = "^(notificationtoasts)" },
	no_initial_focus = true,
	pin = true,
})
hl.window_rule({
	match = { class = "^(firefox)$", title = "^(Picture-in-Picture)$" },
	float = true,
})

-- Let XWayland apps float
hl.window_rule({
    name = "fix-xwayland",
    match = { xwayland = 1 },
    float = true,
})

-- Fix some dragging issues with XWayland
-- hl.window_rule({
--     name  = "fix-xwayland-drags",
--     match = {
--         class      = "^$",
--         title      = "^$",
--         xwayland   = true,
--         float      = true,
--         fullscreen = false,
--         pin        = false,
--     },
--
--     no_focus = true,
-- })

hl.window_rule({
    name = "Firefox-ws2",
    match = { class = "firefox" },
    workspace = 2,
    maximize = true,
})

hl.window_rule({
    name = "Obsidian-ws3",
    match = { class = "md.obsidian.Obsidian" },
    workspace = 3,
    fullscreen = true,
})

hl.window_rule({
    name = "Heroic-ws5",
    match = { class = "heroic" },
    border_size = 0,
    workspace = 4,
    maximize = true,
})

hl.window_rule({
    name = "Cancer Java apps",
    match = { class = "(ghidra-Ghidra|burp-StartBurp)"},
    -- workspace = 4,
    border_size = 0,
    rounding = 0,
    decorate = false,
})

hl.window_rule({ match = { class = "^(zoom)$" }, float = true })
hl.layer_rule({ match = { namespace = "^(quickshell)$" }, no_anim = true })
hl.layer_rule({ match = { namespace = "^dms:.*" }, no_anim = true })

require("dms.colors")
require("dms.outputs")
require("dms.layout")
require("dms.cursor")
require("dms.input")
require("dms.binds")
require("dms.binds-user")
require("dms.windowrules")
