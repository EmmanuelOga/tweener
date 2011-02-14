local tweener = require "tweener.base"
local easing = require "tweener.easing"

RADIUS = 250
W, H, OFFSET, DURATION = 800, 600, 100, 2

local tangle = tweener("loopforward")

-- put all easing function names inside an array for easy navigation by array index.
local functions = {}
for funName, _ in pairs(easing) do functions[#functions + 1] = funName end
table.sort(functions)
local selFunPos = 7

function love.load()
  love.graphics.setLine(2, "smooth")

  tangle.add(0,        { angle = 0 },           easing[functions[selFunPos]])
  tangle.add(DURATION, { angle = 2 * math.pi }, easing[functions[selFunPos]])
  tangle.add(0,        { angle = 0 },           easing[functions[selFunPos]])
end

local function renderWithAngle(angle)
  local x = math.sin(angle) * RADIUS
  local y = math.cos(angle) * RADIUS
  love.graphics.circle("fill", W / 2 + x, H / 2 + y, 25, 25)
end

local lastangle = 0
function love.draw()
  local angle = tangle.getCurrentProperties().angle

  love.graphics.setColor(0, 255, 0, 232)
  renderWithAngle(angle)
  love.graphics.setColor(255, 0, 255, 232)
  renderWithAngle(lastangle)

  lastangle = angle

  love.graphics.setColor(255, 0, 0, 255)
  love.graphics.print("Press left and right to change the easing functions.", 10, 10)
  love.graphics.print("Postion: " .. selFunPos .. "/" .. #functions .. " - " .. functions[selFunPos], 10, 30)
end

function love.update(dt)
  tangle.update(dt)
end

local function updateEasingFuncs()
  for _, t in tangle.eachTween() do t.f = easing[functions[selFunPos]] end
end

function love.keypressed(key, unicode)
  if key == 'left' then
    if selFunPos > 1 then selFunPos = selFunPos - 1 end; updateEasingFuncs()
  elseif key == 'right' then
    if selFunPos < #functions then selFunPos = selFunPos + 1 end; updateEasingFuncs()
  end
end
