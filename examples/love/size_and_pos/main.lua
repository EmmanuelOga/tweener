local tweener = require "tweener.base"
local easing = require "tweener.easing"

W = 800
H = 600
OFFSET = 100
DURATION = 2

local tpos = tweener("loopforward")
local tsize = tweener("loopforward")

-- put all easing function names inside an array for easy navigation by array index.
local functions = {}
for funName, _ in pairs(easing) do functions[#functions + 1] = funName end
table.sort(functions)
local selFunPos, selFunSize = 1, 1

function love.load()
  love.graphics.setLineWidth(2)
  love.graphics.setLineStyle("smooth")

  tpos.add(DURATION, { x = OFFSET,     y = OFFSET }, easing[functions[selFunPos]])
  tpos.add(DURATION, { x = W - OFFSET, y = OFFSET }, easing[functions[selFunPos]])
  tpos.add(DURATION, { x = W - OFFSET, y = H - OFFSET }, easing[functions[selFunPos]])
  tpos.add(DURATION, { x = OFFSET,     y = H - OFFSET }, easing[functions[selFunPos]])
  tpos.add(DURATION, { x = OFFSET,     y = OFFSET }, easing[functions[selFunPos]])

  tsize.add(DURATION, { size = 20 }, easing[functions[selFunSize]])
  tsize.add(DURATION, { size = 100 }, easing[functions[selFunSize]])
end

function love.draw()
  local ppos = tpos.getCurrentProperties()
  local psize = tsize.getCurrentProperties()

  love.graphics.setColor(0, 0, 255, 255)
  love.graphics.line(OFFSET, OFFSET, W - OFFSET, OFFSET, W - OFFSET, H - OFFSET, OFFSET, H - OFFSET, OFFSET, OFFSET)

  love.graphics.setColor(0, 255, 0, 255)
  love.graphics.circle("fill", ppos.x, ppos.y, psize.size, 25)

  love.graphics.setColor(255, 0, 0, 255)
  love.graphics.print("Press up and down, left and right to change the easing functions.", 10, 10)
  love.graphics.print("Postion: " .. selFunPos .. "/" .. #functions .. " - " .. functions[selFunPos], 10, 30)
  love.graphics.print("Size: " .. selFunSize .. "/" .. #functions .. " - " .. functions[selFunSize], 10, 50)
end

function love.update(dt)
  tpos.update(dt)
  tsize.update(dt)
end

local function updateEasingFuncs(ts, sel)
  for _, t in ts.eachTween() do t.f = easing[functions[sel]] end
end

function love.keypressed(key, unicode)
  if key == 'down' then
    if selFunSize > 1 then selFunSize = selFunSize - 1 end; updateEasingFuncs(tsize, selFunSize)
  elseif key == 'up' then
    if selFunSize < #functions then selFunSize = selFunSize + 1 end; updateEasingFuncs(tsize, selFunSize)
  elseif key == 'left' then
    if selFunPos > 1 then selFunPos = selFunPos - 1 end; updateEasingFuncs(tpos, selFunPos)
  elseif key == 'right' then
    if selFunPos < #functions then selFunPos = selFunPos + 1 end; updateEasingFuncs(tpos, selFunPos)
  end
end
