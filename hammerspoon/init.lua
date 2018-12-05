hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

hs.loadSpoon("SpeedMenu")

hs.hotkey.bind({"alt"}, "h", function()
    hs.window.focusedWindow():focusWindowWest(nil, false, true)
end)
hs.hotkey.bind({"alt"}, "j", function()
    hs.window.focusedWindow():focusWindowSouth(nil, false, true)
end)
hs.hotkey.bind({"alt"}, "k", function()
    hs.window.focusedWindow():focusWindowNorth(nil, false, true)
end)
hs.hotkey.bind({"alt"}, "l", function()
    hs.window.focusedWindow():focusWindowEast(nil, false, true)
end)

hs.hotkey.bind({"alt"}, "b", function()
    hs.execute("open /Applications/Google\\ Chrome.app --new --args --new-window about:home")
end)

hs.hotkey.bind({"alt"}, "d", function()
    hs.caffeinate.lockScreen()
end)

hs.hotkey.bind({"alt"}, "f", function()
    hs.window.focusedWindow():toggleFullScreen()
end)

hs.hotkey.bind({"alt"}, "o", function()
    hs.execute("open -n /Applications/Alacritty.app/")
end)

hs.hotkey.bind({"alt"}, "q", function()
    hs.window.focusedWindow():close()
end)

hs.hotkey.bind({"alt"}, "r", function()
    hs.eventtap.keyStroke({"cmd"}, "space")
end)

hs.hotkey.bind({"alt"}, "[", function()
    hs.eventtap.keyStroke({"ctrl"}, "left")
end)

hs.hotkey.bind({"alt"}, "]", function()
    hs.eventtap.keyStroke({"ctrl"}, "right")
end)

hs.hotkey.bind({"cmd"}, "h", function()
    -- nothing
end)

hs.hotkey.bind({"cmd"}, "u", function()
    hs.eventtap.keyStroke({"cmd"}, "delete")
end)

hs.hotkey.bind({"cmd"}, "a", function()
    hs.eventtap.keyStroke({"cmd"}, "left")
end)

hs.hotkey.bind({"cmd"}, "e", function()
    hs.eventtap.keyStroke({"cmd"}, "right")
end)

for i = 1, 6 do
    hs.hotkey.bind({"alt"}, tostring(i), function()
        hs.eventtap.keyStroke({"ctrl"}, tostring(i))
    end)
end

-- bindings for window movement are handled by amethyst, since hammerspoon
-- doesn't support that well

extra_bindings = {
    ["Alacritty"] = hs.hotkey.modal.new(),
    ["Google Chrome"] = hs.hotkey.modal.new(),
}

slack_cmd_k_watcher = nil
extra_bindings["Alacritty"]:bind({"ctrl"}, "k", function()
    slack_cmd_k_watcher = hs.application.watcher.new(function(name, event_type, app)
        if event_type == hs.application.watcher.activated then
            if app:name() == "Slack" then
                hs.timer.doAfter(0.001, function()
                    hs.eventtap.keyStroke({"cmd"}, "k")
                end)
                slack_cmd_k_watcher:stop()
                slack_cmd_k_watcher = nil
            end
        end
    end)
    slack_cmd_k_watcher:start()
    hs.application.get("Slack"):mainWindow():focus()
end)

extra_bindings["Google Chrome"]:bind({"cmd"}, "h", function()
    hs.eventtap.keyStroke({"cmd"}, "left")
end)

extra_bindings["Google Chrome"]:bind({"cmd"}, "l", function()
    hs.eventtap.keyStroke({"cmd"}, "right")
end)

-- doesn't seem to work?
-- extra_bindings["Google Chrome"]:bind({"cmd", "shift"}, "i", function()
--     hs.eventtap.keyStroke({"cmd", "option"}, "i")
-- end)

possibly_active_apps = {}
current_app_name = nil

function enter_bindings(name)
    if extra_bindings[name] then
        extra_bindings[name]:enter()
        current_app_name = name
    end
end

function exit_bindings(name)
    if extra_bindings[name] then
        extra_bindings[name]:exit()
        current_app_name = nil
    end
end

-- the application watcher receives notifications about new apps being
-- activated before the old apps are deactivated, so we have to hack around
-- that a bit
current_application_watcher = hs.application.watcher.new(function(name, event_type, app)
    if event_type == hs.application.watcher.activated then
        possibly_active_apps[app:pid()] = app
    elseif event_type == hs.application.watcher.deactivated then
        possibly_active_apps[app:pid()] = nil
    end

    apps = {}
    for _, v in pairs(possibly_active_apps) do
        table.insert(apps, v)
    end

    if #apps == 1 and apps[1]:name() ~= current_app_name then
        exit_bindings(current_app_name)
        enter_bindings(apps[1]:name())
    end
end)
enter_bindings(hs.application.frontmostApplication():name())
current_application_watcher:start()

cpu_usage_bar = hs.menubar.new()
timer = hs.timer.doEvery(1, function()
    hs.host.cpuUsage(function(cpu)
        local cpuUsage = cpu["overall"]["active"]
        cpu_usage_bar:setTitle(math.floor(cpuUsage + 0.5) .. "%")
    end)
end)

power_usage_bar = hs.menubar.new()
timer = hs.timer.doEvery(5, function()
    local watts = hs.execute("/Users/doy/.bin/st-doy1.local/power-usage")
    power_usage_bar:setTitle(string.gsub(watts, "\n", "") .. "W")
end)

hs.caffeinate.set("systemIdle", true, true)

hs.alert("Hammerspoon config reloaded")
