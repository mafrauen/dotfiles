local application = require "mjolnir.application"
local hotkey = require "mjolnir.hotkey"
local window = require "mjolnir.window"
local fnutils = require "mjolnir.fnutils"
local alert = require "mjolnir.alert"
local spotify = require "mjolnir.lb.spotify"

local mNone = {}
local mShift = {"shift"}
local mCtrl = {"ctrl"}

local allKeys = {}

local disableKey = nil
local enableKey = nil

-- Set up modes
disableKey = hotkey.new(mCtrl, '[', function ()
  disableKey:disable()
  for key, value in next,allKeys,nil do
    value:disable()
  end
  enableKey:enable()
end)

enableKey = hotkey.new(mCtrl, "space", function ()
  enableKey:disable()
  for key, value in next,allKeys,nil do
    value:enable()
  end
  disableKey:enable()
end)
enableKey:enable()


-- Window position functions
function coords(pos)
  return function ()
    local win = window.focusedwindow()
    local screenrect = win:screen():fullframe()
    local x, y, w, h = table.unpack(pos)
    local frame = {
      x = screenrect.x + (screenrect.w * x),
      y = screenrect.y + (screenrect.h * y),
      w = screenrect.w * w,
      h = screenrect.h * h,
    }
    win:setframe(frame)
  end
end

function pos(x, y)
  return function()
    local scalar = 40
    local win = window.focusedwindow()
    local frame = win:frame()
    frame.x = frame.x + x * scalar
    frame.y = frame.y + y * scalar
    win:setframe(frame)
  end
end

function size(w, h)
  return function()
    local scalar = 40
    local win = window.focusedwindow()
    local frame = win:frame()
    frame.w = frame.w + w * scalar
    frame.h = frame.h + h * scalar
    win:setframe(frame)
  end
end

function cycle(fn, units)
  local values = fnutils.cycle(units)
  return function ()
    fn(values())()
  end
end

function bindKey(modifier, key, fn)
  table.insert(allKeys, 1, hotkey.new(modifier, key, fn))
end

-- Move window to next screen
bindKey(mCtrl, 'N', function ()
  local win = window.focusedwindow()
  local currentScreen = win:screen():fullframe()
  local nextScreen = win:screen():next():fullframe()
  local windowFrame = win:frame()

  local frame = {
    x = nextScreen.x + (nextScreen.w * ((windowFrame.x - currentScreen.x) / currentScreen.w)),
    y = nextScreen.y + (nextScreen.h * ((windowFrame.y - currentScreen.y) / currentScreen.h)),
    w = windowFrame.w * (nextScreen.w / currentScreen.w),
    h = windowFrame.h * (nextScreen.h / currentScreen.h),
  }
  win:setframe(frame)
end)

-- Center window
bindKey(mNone, 'C', cycle(coords, {
  {.22, .025, .56, .95},
  {.1, 0, .8, 1}
}))

-- Maximize window
bindKey(mNone, 'M', coords({0, 0, 1, 1}))

-- Left/right/top/bottom
bindKey(mCtrl, 'H', coords({0, 0, .5, 1}))
bindKey(mCtrl, 'L', coords({.5, 0, .5, 1}))
bindKey(mCtrl, 'J', coords({0, .5, 1, .5}))
bindKey(mCtrl, 'K', coords({0, 0, 1, .5}))

-- Screen corners
bindKey(mNone, 'Q', coords({0, 0, .5, .5}))
bindKey(mNone, 'W', coords({.5, 0, .5, .5}))
bindKey(mNone, 'A', coords({0, .5, .5, .5}))
bindKey(mNone, 'S', coords({.5, .5, .5, .5}))

-- Window movement
bindKey(mNone, 'H', pos(-1, 0))
bindKey(mNone, 'J', pos(0, 1))
bindKey(mNone, 'K', pos(0, -1))
bindKey(mNone, 'L', pos(1, 0))

-- Window size
bindKey(mShift, 'H', size(-1, 0))
bindKey(mShift, 'J', size(0, 1))
bindKey(mShift, 'K', size(0, -1))
bindKey(mShift, 'L', size(1, 0))

-- Application specific positions
bindKey(mNone, 'Z', coords({0, .4, .7, .6}))
bindKey(mShift, 'Z', coords({0, .66, 1, .34}))
bindKey(mNone, 'X', coords({.3, .05, .65, .9}))

bindKey(mNone, 'G', function ()
  spotify.displayCurrentTrack()
end)

-- Show the time
bindKey(mNone, 'T', function ()
  alert.show(os.date("%I:%M"), .5)
end)