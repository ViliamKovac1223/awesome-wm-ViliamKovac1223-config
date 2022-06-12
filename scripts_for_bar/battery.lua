local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local gears = require("gears")
require("utility")

local widget = {}

local function worker(args)
    local args = args or {}

    local time_to_update = args.time_to_update or 15 -- time to update
    local shape = gears.shape.rounded_bar
    local font = args.font or 'Play 6'
    local fg = args.fg or "#1C1C1C"
    local shape_border_color = args.shape_border_color or beautiful.border_color
    local shape_border_width = args.shape_border_width or beautiful.border_width
    local charging_symbol = args.charging_symbol or "<"
    local dis_charging_symbol = args.dis_charging_symbol or ">"
    local full_battery_symbol = args.full_battery_symbol or ""

    local low_level_battery_bg = args.low_battery_bg or "#e70000"
    local mid_level_battery_bg = args.mid_battery_bg or "#FFFF33" 
    local high_level_battery_bg = args.high_battery_bg or "#90EE90"

    local low_level_battery = args.low_level_battery or 15
    local mid_level_battery = args.mid_level_battery or 50

    local widget = wibox.widget {
        widget = wibox.widget.textbox,
    }

    local container = wibox.widget {
        widget,
        shape = shape,
        font = font,
        bg = beautiful.bg_normal,
        fg = fg,
        shape_border_color = shape_border_color,
        shape_border_width = shape_border_width,
        widget = wibox.container.background
    }


    home = os.getenv("HOME");
    watch('bash -c "sh ' .. home .. 
        '/.config/awesome/scripts_for_bar/battery.sh ' .. time_to_update * 1000 .. " " .. low_level_battery .. '"',
        time_to_update,
        function(container, stdout)
            stdout = string.gsub(stdout, "\n", "") -- remove line break

            battery = Split(stdout, " ")
            battery_capacity = battery[2]
            battery_status = battery[1]

            -- set widget background
            local battery_capacity = tonumber(battery_capacity)
            if battery_capacity <= low_level_battery then
                container.bg = low_level_battery_bg
            elseif battery_capacity <= mid_level_battery then
                container.bg = mid_level_battery_bg
            else
                container.bg = high_level_battery_bg
            end

            -- set symbol of charging and discharging
            if battery_status == "Charging" and battery_capacity ~= 100 then
                battery_status = charging_symbol
            elseif battery_status == "Discharging" and battery_capacity ~= 100 then
                battery_status = dis_charging_symbol
            elseif battery_status == "Full" then
                battery_status = full_battery_symbol
            else 
                battery_status = ""
            end

            widget:set_text(" " .. battery_status .. battery_capacity .. "%" .. " ")
        end,
    container)

    return container
end

return setmetatable(widget, { __call = function(_, ...)
    return worker(...)
end })
