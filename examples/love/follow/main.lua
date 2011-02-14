local tweener = require "tweener.base"
local easing = require "tweener.easing"

RADIUS = 250
W, H, OFFSET, DURATION = 800, 600, 100, 1

local tnext = tweener("loopforward")

-- put all easing function names inside an array for easy navigation by array index.
local functions = {}
for funName, _ in pairs(easing) do functions[#functions + 1] = funName end
table.sort(functions)
local selFunPos = 23

function love.load()
  love.graphics.setLine(2, "smooth")
  love.graphics.setFont(24)

  tnext.add(DURATION, { x = W / 2, y = H / 2 }, easing[functions[selFunPos]])
end

function renderPath()
  local allPoints = {}
  for i, t in tnext.eachTween() do
    allPoints[#allPoints + 1] = t.p.x
    allPoints[#allPoints + 1] = t.p.y
  end

  if #allPoints > 3 then
    love.graphics.setColor(0, 0, 255, 232)
    love.graphics.line(unpack(allPoints))

    for i, t in tnext.eachTween() do love.graphics.print(i, t.p.x, t.p.y) end
  end
end

local lastx, lasty = 0, 0
function love.draw()
  renderPath()

  local tpos = tnext.getCurrentProperties()

  love.graphics.setColor(0, 255, 0, 232)
  love.graphics.circle("fill", tpos.x, tpos.y, 50, 50)
  love.graphics.setColor(0, 255, 0, 232)
  love.graphics.circle("fill", lastx, lasty, 50, 50)

  lastx, lasty = tpos.x, tpos.y

  love.graphics.setColor(255, 0, 0, 255)
  love.graphics.print("Right click to draw a path, left click to reset.", 10, 10)
  love.graphics.print("Press left and right to change the easing functions.", 10, 40)
  love.graphics.print("Postion: " .. selFunPos .. "/" .. #functions .. " - " .. functions[selFunPos], 10, 70)

  local t, i = tnext.getCurrent()

  love.graphics.print("Position: " .. i .. " of " .. tnext.getLength(), 10, 100)
  love.graphics.print("Mode: " .. tnext.getMode(), 10, 130)
end

function love.update(dt)
  tnext.update(dt)
end

local function updateEasingFuncs()
  for _, t in tnext.eachTween() do t.f = easing[functions[selFunPos]] end
end

function love.keypressed(key, unicode)
  if key == 'left' then
    if selFunPos > 1 then selFunPos = selFunPos - 1 end; updateEasingFuncs()
  elseif key == 'right' then
    if selFunPos < #functions then selFunPos = selFunPos + 1 end; updateEasingFuncs()
  end
end

function love.mousepressed(x, y, button)
  if button == 'l' then
    tnext.add(DURATION, { x = x, y = y }, easing[functions[selFunPos]])
  elseif button == 'r' then
    tnext.reset()
    tnext.add(DURATION, { x = W / 2, y = H / 2 }, easing[functions[selFunPos]])
  end
end
