local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local gears = require("gears")

local widget = {}

local function worker(args)
    local args = args or {}

    local time_to_update = args.time_to_update or 3 -- time to update widget
    local shape = args.shape or gears.shape.base
    local font = args.font or 'Play 6'
    local bg = args.bg or beautiful.bg_normal
    local shape_border_color = args.shape_border_color or beautiful.border_color
    local shape_border_width = args.shape_border_width or beautiful.border_width
    local microphone_icon = args.microphone_icon or '  '
    local microphone_icon_mute = args.microphone_icon_mute or '  '

    local temp_fg = args.high_level_temp_fg or beautiful.fg

    local widget = wibox.widget {
        widget = wibox.widget.textbox,
    }

    local container = wibox.widget {
        widget,
        shape = shape,
        font = font,
        bg = bg,
        fg = beautiful.fg_normal,
        shape_border_color = shape_border_color,
        shape_border_width = shape_border_width,
        widget = wibox.container.background
    }
    

    -- amixer | grep "'Capture',0" -A 5 | tail -n 1 | awk '{ print $5, $6 }' | sed -e 's/\[//g' -e 's/\]//g' # get mic info in format xxx% on/off
    watch('bash -c "amixer | grep \'Capture\' -A 5 | grep \',0\' -A 5 | tail -n 1 | awk \'{ print $5, $6 }\' | sed -e \'s/\\[//g\' -e \'s/\\]//g\' "',
        time_to_update,
        function(container, stdout)
            stdout = string.gsub(stdout, "\n", "") -- remove line break so we can add icon at the end

            container.fg = temp_fg

            widget:set_text(microphone_icon .. stdout .. "")
        end,
    container)

    return container
end

return setmetatable(widget, { __call = function(_, ...)
    return worker(...)
end })
