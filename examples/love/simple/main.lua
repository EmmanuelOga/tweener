local tweener = require "tweener.base"
local easing = require "tweener.easing"

W, H, OFFSET, DURATION = 800, 600, 100, 1

local tpos = tweener("loopforward")

-- put all easing function names inside an array for easy navigation by array index.
local functions = {}
for funName, _ in pairs(easing) do functions[#functions + 1] = funName end
table.sort(functions)
local selFunPos = 7

function love.load()
  love.graphics.setLine(2, "smooth")

  tpos.add(DURATION, { x = OFFSET,     y = OFFSET }, easing[functions[selFunPos]]) -- a
  tpos.add(DURATION, { x = W - OFFSET, y = OFFSET }, easing[functions[selFunPos]]) -- b
  tpos.add(DURATION, { x = W - OFFSET, y = H - OFFSET }, easing[functions[selFunPos]]) -- c
  tpos.add(DURATION, { x = OFFSET,     y = H - OFFSET }, easing[functions[selFunPos]]) -- d
  tpos.add(DURATION, { x = OFFSET,     y = OFFSET }, easing[functions[selFunPos]]) -- a
  tpos.add(DURATION, { x = W - OFFSET, y = H - OFFSET }, easing[functions[selFunPos]]) -- c
  tpos.add(DURATION, { x = OFFSET,     y = H - OFFSET }, easing[functions[selFunPos]]) -- d
  tpos.add(DURATION, { x = W - OFFSET, y = OFFSET }, easing[functions[selFunPos]]) -- b
end

local lastX, lastY = 0, 0
function love.draw()
  local ppos = tpos.getCurrentProperties()

  love.graphics.setColor(0, 0, 255, 255)
  love.graphics.line(OFFSET, OFFSET, W - OFFSET, OFFSET, W - OFFSET, H - OFFSET, OFFSET, H - OFFSET, OFFSET, OFFSET)

  love.graphics.setColor(255, 0, 255, 255)
  love.graphics.circle("fill", lastX, lastY, 25, 25)

  love.graphics.setColor(0, 255, 0, 232)
  love.graphics.circle("fill", ppos.x, ppos.y, 25, 25)

  lastX, lastY = ppos.x, ppos.y

  love.graphics.setColor(255, 0, 0, 255)
  love.graphics.print("Press left and right to change the easing functions.", 10, 10)
  love.graphics.print("Postion: " .. selFunPos .. "/" .. #functions .. " - " .. functions[selFunPos], 10, 30)
end

function love.update(dt)
  tpos.update(dt)
end

local function updateEasingFuncs()
  for _, t in tpos.eachTween() do t.f = easing[functions[selFunPos]] end
end

function love.keypressed(key, unicode)
  if key == 'left' then
    if selFunPos > 1 then selFunPos = selFunPos - 1 end; updateEasingFuncs()
  elseif key == 'right' then
    if selFunPos < #functions then selFunPos = selFunPos + 1 end; updateEasingFuncs()
  end
end
