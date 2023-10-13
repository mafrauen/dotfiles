hs.window.animationDuration = 0

local mNone = {}
local mShift = {"shift"}
local mCtrl = {"ctrl"}

local allKeys = {}

local disableKey = nil
local enableKey = nil

function doEnable()
  enableKey:disable()
  for key, value in next,allKeys,nil do
    value:enable()
  end
  disableKey:enable()
end

function doDisable()
  disableKey:disable()
  for key, value in next,allKeys,nil do
    value:disable()
  end
  enableKey:enable()
end

-- Set up modes
disableKey = hs.hotkey.new(mCtrl, '[',  doDisable)

enableKey = hs.hotkey.new(mCtrl, "space", doEnable)
enableKey:enable()


-- Window position functions
function coords(pos)
  return function ()
    local win = hs.window.focusedWindow()
    local screenrect = win:screen():fullFrame()
    local x, y, w, h = table.unpack(pos)
    local frame = {
      x = screenrect.x + (screenrect.w * x),
      y = screenrect.y + (screenrect.h * y),
      w = screenrect.w * w,
      h = screenrect.h * h,
    }
    win:setFrame(frame)
  end
end

function pos(x, y)
  return function()
    local scalar = 40
    local win = hs.window.focusedWindow()
    local frame = win:frame()
    frame.x = frame.x + x * scalar
    frame.y = frame.y + y * scalar
    win:setFrame(frame)
  end
end

function size(w, h)
  return function()
    local scalar = 40
    local win = hs.window.focusedWindow()
    local frame = win:frame()
    frame.w = frame.w + w * scalar
    frame.h = frame.h + h * scalar
    win:setFrame(frame)
  end
end

function cycle(fn, units)
  local values = hs.fnutils.cycle(units)
  return function ()
    fn(values())()
  end
end

function bindKey(modifier, key, fn)
  table.insert(allKeys, 1, hs.hotkey.new(modifier, key, fn))
end

-- Move window to next screen
bindKey(mCtrl, 'N', function ()
  local win = hs.window.focusedWindow()
  local currentScreen = win:screen():fullFrame()
  local nextScreen = win:screen():next():fullFrame()
  local windowFrame = win:frame()

  local frame = {
    x = nextScreen.x + (nextScreen.w * ((windowFrame.x - currentScreen.x) / currentScreen.w)),
    y = nextScreen.y + (nextScreen.h * ((windowFrame.y - currentScreen.y) / currentScreen.h)),
    w = windowFrame.w * (nextScreen.w / currentScreen.w),
    h = windowFrame.h * (nextScreen.h / currentScreen.h),
  }
  win:setFrame(frame)
end)

-- Center window
-- bindKey(mNone, 'C', cycle(coords, {
--   {.2, .08, .6, .84},
--   {.1, 0, .8, 1}
-- }))
-- Maximize window
bindKey(mNone, 'C', coords({.1, 0, .8, 1}))
-- Center window
bindKey(mShift, 'C', coords({.2, .08, .6, .84}))

-- Maximize window
bindKey(mNone, 'M', coords({0, 0, 1, 1}))

-- Mid center-right
bindKey(mNone, 'X', coords({.45, .1, .5, .8}))

-- Mid center-left
bindKey(mShift, 'X', coords({.05, .1, .35, .8}))

-- Left/right/top/bottom
bindKey(mCtrl, 'H', coords({0, 0, .5, 1}))
bindKey(mCtrl, 'L', coords({.5, 0, .5, 1}))
bindKey(mCtrl, 'J', coords({0, .5, 1, .5}))
bindKey(mCtrl, 'K', coords({0, 0, 1, .5}))

-- Screen corners
bindKey(mShift, 'Q', coords({0, 0, .5, .5}))
bindKey(mShift, 'W', coords({.5, 0, .5, .5}))
bindKey(mShift, 'A', coords({0, .5, .5, .5}))
bindKey(mShift, 'S', coords({.5, .5, .5, .5}))

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
-- Left full (terminal)
bindKey(mShift, 'T', coords({0, 0, .75, 1}))
-- mid center (zoom)
bindKey(mNone, 'Z', coords({.15, 0, .7, .8}))
-- mid center small (zoom)
bindKey(mShift, 'Z', coords({.2, 0, .6, .5}))
-- Top right(slack)
bindKey(mNone, 'S', coords({.2, 0, .8, .65}))

bindKey(mNone, 'G', function ()
  doDisable()
  hs.hints.windowHints(nil, function (win)
    doEnable()
  end)
end)

-- Show the time
bindKey(mNone, 'T', function ()
  -- 12 hour time
  -- hs.alert.show(os.date("%I:%M"), .5)
  -- 24 hour time
  hs.alert.show(os.date("%H:%M"), .5)
end)
