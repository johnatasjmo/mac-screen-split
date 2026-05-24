# Mac Screen Split - Hammerspoon Window Manager

Window management for an external ultrawide display using [Hammerspoon](https://www.hammerspoon.org), a macOS automation tool.

All hotkeys target the **external display only** (any non-built-in screen). Windows on your laptop screen are unaffected.

## Setup

1. Install Hammerspoon:
   ```
   brew install --cask hammerspoon
   ```
2. Clone this repo into your Hammerspoon config directory:
   ```
   git clone git@github.com:johnatasjmo/mac-screen-split.git ~/.hammerspoon
   ```
3. Launch Hammerspoon from Applications.
4. Grant **Accessibility** permissions when prompted (System Settings > Privacy & Security > Accessibility).
5. You should see a "Hammerspoon config loaded" alert — you're ready.

## Hotkeys

All shortcuts use **Cmd + Ctrl** plus an arrow key. Double-tap means pressing the same shortcut twice quickly.

| Shortcut | Tap | Action |
|---|---|---|
| `Cmd + Ctrl + Left` | single | Left **50%** |
| `Cmd + Ctrl + Left` | double | Left **1/3** |
| `Cmd + Ctrl + Up` | single | Center **60%** |
| `Cmd + Ctrl + Up` | double | Center **1/3** |
| `Cmd + Ctrl + Right` | single | Right **50%** |
| `Cmd + Ctrl + Right` | double | Right **1/3** |

### Visual layout

```
Single tap:
|████████░░░░░░░░|  Left 50%
|░░░░████████░░░░|  Center 60%
|░░░░░░░░████████|  Right 50%

Double tap:
|█████░░░░░░░░░░░|  Left 1/3
|░░░░░█████░░░░░░|  Center 1/3
|░░░░░░░░░░█████░|  Right 1/3  (not to scale, you get the idea)
```

## How it works

- **External display detection**: Excludes any screen named "Built-in", "Color LCD", or "Retina" and uses the first remaining screen.
- **Double-tap detection**: A second press within 300ms triggers the 1/3 layout instead of the 50%/60% layout. Single taps have a slight delay (~300ms) while waiting for a possible second tap.
- **Positioning**: The `moveToSamsung(x, y, w, h)` function takes fractional coordinates (0-1) relative to the external screen's frame.

## Reloading after changes

After editing `init.lua`, reload the config:
- Click the Hammerspoon menu bar icon (hammer) > **Reload Config**
- Or open the Hammerspoon console and run `hs.reload()`

## Customizing

Edit `init.lua` directly. Common changes:

- **Adjust double-tap speed**: Change `doubleTapInterval` (default `0.3` seconds).
- **Change center width**: Modify the `0.6` in the Up arrow single-tap binding. The x offset should be `(1 - width) / 2` to keep it centered.
- **Add new layouts**: Use `bindDoubleTap(key, singleFn, doubleFn)` for keys with two actions, or `hs.hotkey.bind(...)` for simple single-action keys.

### Fraction reference

```
x = horizontal offset  (0 = left edge, 1 = right edge)
y = vertical offset    (0 = top edge,  1 = bottom edge)
w = width fraction     (1 = full width)
h = height fraction    (1 = full height)
```

## Troubleshooting

- **"External display not found"**: No external monitor detected. Check connected displays in the Hammerspoon console: `for _, s in ipairs(hs.screen.allScreens()) do print(s:name()) end`
- **Hotkeys not working**: Verify Accessibility permissions are granted and Hammerspoon is running (hammer icon in menu bar).
- **Single tap feels slow**: The 300ms delay is intentional — it waits for a possible double-tap. Lower `doubleTapInterval` to `0.2` for faster response (but harder to double-tap).
