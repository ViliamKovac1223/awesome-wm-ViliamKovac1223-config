local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local gears = require("gears")

local widget = {}

local function worker(args)
    local args = args or {}

    local time_to_update = args.time_to_update or 2 -- time to update widget
    local shape = args.shape or gears.shape.base
    local font = args.font or 'Play 6'
    local bg = args.bg or beautiful.bg_normal
    local fg = args.fg or beautiful.fg_normal
    local shape_border_color = args.shape_border_color or beautiful.border_color
    local shape_border_width = args.shape_border_width or beautiful.border_width

    local widget = wibox.widget {
        widget = wibox.widget.textbox,
    }

    local container = wibox.widget {
        widget,
        shape = shape,
        font = font,
        bg = bg,
        fg = fg,
        shape_border_color = shape_border_color,
        shape_border_width = shape_border_width,
        widget = wibox.container.background
    }
    

    home = os.getenv("HOME");

    watch('bash -c "sh ' .. home ..  '/.config/awesome/scripts_for_bar/brightness.sh"',
        time_to_update,
        function(container, stdout)
            widget:set_text(stdout)
        end,
    container)

    return container
end

return setmetatable(widget, { __call = function(_, ...)
    return worker(...)
end })
