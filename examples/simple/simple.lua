local tweener = require "tweener.base"
local easing = require "tweener.easing"

local ts = tweener("forward")

ts.add(1, { x = 1, y = 1, z = true }, easing.linear)
ts.add(1, { x = 2, y = 2, z = false }, easing.linear)

local function printProps()
  p = ts.getCurrentProperties()
  print("x:", p.x, "y:", p.y, "z:", p.z, "elapsed:", ts.getElapsed())
end

for i = 1, 15 do
  printProps()
  ts.update(0.1)
end

-- ▸ lua examples/simple/simple.lua
-- x:	1	y:	1	z:	true	elapsed:	0
-- x:	1.1	y:	1.1	z:	true	elapsed:	0.1
-- x:	1.2	y:	1.2	z:	true	elapsed:	0.2
-- x:	1.3	y:	1.3	z:	true	elapsed:	0.3
-- x:	1.4	y:	1.4	z:	true	elapsed:	0.4
-- x:	1.5	y:	1.5	z:	true	elapsed:	0.5
-- x:	1.6	y:	1.6	z:	true	elapsed:	0.6
-- x:	1.7	y:	1.7	z:	true	elapsed:	0.7
-- x:	1.8	y:	1.8	z:	true	elapsed:	0.8
-- x:	1.9	y:	1.9	z:	true	elapsed:	0.9
-- x:	2	y:	2	z:	false	elapsed:	0
-- x:	2	y:	2	z:	false	elapsed:	0.1
-- x:	2	y:	2	z:	false	elapsed:	0.2
-- x:	2	y:	2	z:	false	elapsed:	0.3
-- x:	2	y:	2	z:	false	elapsed:	0.4
