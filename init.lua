-- Hammerspoon config: Samsung 3440x1440 ultrawide window management
-- Hotkeys move the focused window ON the Samsung (secondary) display only.
-- If the focused window is not on the Samsung, it is moved there first.

--- Find the external display (any screen that is not the built-in laptop screen).
local function getExternalDisplay()
  for _, s in ipairs(hs.screen.allScreens()) do
    local name = (s:name() or ""):lower()
    if not name:find("built%-in") and not name:find("color lcd") and not name:find("retina") then
      return s
    end
  end
  return nil
end

--- Move the focused window to a portion of the Samsung screen.
-- @param x      fraction offset from left  (0-1)
-- @param y      fraction offset from top   (0-1)
-- @param w      fraction of screen width   (0-1)
-- @param h      fraction of screen height  (0-1)
local function moveToSamsung(x, y, w, h)
  local win = hs.window.focusedWindow()
  if not win then return end

  local scr = getExternalDisplay()
  if not scr then
    hs.alert.show("External display not found")
    return
  end

  local frame = scr:frame()
  win:setFrame(hs.geometry.rect(
    frame.x + (frame.w * x),
    frame.y + (frame.h * y),
    frame.w * w,
    frame.h * h
  ))
end

-- Left 50%
hs.hotkey.bind({"cmd", "ctrl"}, "Left", function()
  moveToSamsung(0, 0, 0.5, 1)
end)

-- Right 50%
hs.hotkey.bind({"cmd", "ctrl"}, "Right", function()
  moveToSamsung(0.5, 0, 0.5, 1)
end)

-- Column 1 of 3 (left third)
hs.hotkey.bind({"cmd", "ctrl"}, "1", function()
  moveToSamsung(0, 0, 1/3, 1)
end)

-- Column 2 of 3 (center third)
hs.hotkey.bind({"cmd", "ctrl"}, "2", function()
  moveToSamsung(1/3, 0, 1/3, 1)
end)

-- Column 3 of 3 (right third)
hs.hotkey.bind({"cmd", "ctrl"}, "3", function()
  moveToSamsung(2/3, 0, 1/3, 1)
end)

-- Diagnostic: show all screens on reload
local diag = "Screens:\n"
for _, s in ipairs(hs.screen.allScreens()) do
  local tag = (s == hs.screen.mainScreen()) and "MAIN" or "SEC"
  diag = diag .. s:name() .. " " .. tostring(s:frame()) .. " " .. tag .. "\n"
end
hs.alert.show(diag, 8)
