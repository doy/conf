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

menubar = hs.menubar.new()
timer = hs.timer.doEvery(1, function()
    hs.host.cpuUsage(function(cpu)
        local cpuUsage = cpu["overall"]["active"]
        menubar:setTitle(math.floor(cpuUsage + 0.5) .. "%")
    end)
end)

hs.caffeinate.set("systemIdle", true, true)

hs.alert("Hammerspoon config reloaded")
