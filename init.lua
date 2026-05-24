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

-- Double-tap detection: tracks last press time per key
local doubleTapInterval = 0.3 -- seconds
local lastTap = { Left = 0, Right = 0, Up = 0 }
local tapTimers = { Left = nil, Right = nil, Up = nil }

--- Bind a key with single-tap and double-tap actions.
local function bindDoubleTap(key, singleFn, doubleFn)
  hs.hotkey.bind({"cmd", "ctrl"}, key, function()
    local now = hs.timer.secondsSinceEpoch()
    if tapTimers[key] then
      tapTimers[key]:stop()
      tapTimers[key] = nil
    end
    if (now - lastTap[key]) < doubleTapInterval then
      lastTap[key] = 0
      doubleFn()
    else
      lastTap[key] = now
      tapTimers[key] = hs.timer.doAfter(doubleTapInterval, function()
        singleFn()
        tapTimers[key] = nil
      end)
    end
  end)
end

-- Left arrow: single = left 50%, double = left 1/3
bindDoubleTap("Left",
  function() moveToSamsung(0, 0, 0.5, 1) end,
  function() moveToSamsung(0, 0, 1/3, 1) end
)

-- Right arrow: single = right 50%, double = right 1/3
bindDoubleTap("Right",
  function() moveToSamsung(0.5, 0, 0.5, 1) end,
  function() moveToSamsung(2/3, 0, 1/3, 1) end
)

-- Up arrow: single = center 50%, double = center 1/3
bindDoubleTap("Up",
  function() moveToSamsung(0.25, 0, 0.5, 1) end,
  function() moveToSamsung(1/3, 0, 1/3, 1) end
)

hs.alert.show("Hammerspoon config loaded")
