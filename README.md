tweener
=======

tweener is a lua library to interpolate sets of properties using an
specified easing function.More info on tweening can be found
[here](http://en.wikipedia.org/wiki/Inbetweening).

The easing functions are the ones provided by
the [easing library](https://github.com/emmanueloga/easing), which is
vendor in this repository.

Usage
=====

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

The tweener factory function takes as parameter one of the
following animation modes:

  * forward: moves forward from tween to tween until there are no more.
  * backward: moves backward from tween to tween until there are no more.
  * loopforward: moves forward from tween to tween until there are no more, then starts all over again.
  * loopbackward:  moves backward from tween to tween until there are no more, then starts all over again.
  * pingpong: moves forward till completion, then moves backward till completion, and repeats.

The add function spects to find exactly 3 parameters: an easing
function, a duration for the tween and a set of properties.  When
calling add, you can order the parameters however you like:

    local ts = tweener("forward")

    ts.add(1, { x = 1, y = 1, z = true }, easing.linear)
    ts.add({ x = 1, y = 1, z = true }, 1, easing.linear)
    ts.add(easing.linear, { x = 1, y = 1, z = true }, 1)

If you miss parameters the properties are defaulted to an empty table,
the easing function to the a linear one and the duration to 1 second.

The only properties that are interpolated are the numeric ones. When you
request the properties of a tween you receive all the properties exactly
as you provided them. If the current tween and the next one share a
property, then the value of that property gets interpolated according to
the time elapsed.

Once you set up the tweens you need to periodically update the elapsed
time.

      ts.update(elapsedSecondsSinceLastUpdate)

Finally, to retrieve the properties you call:

      local p = ts.getCurrentProperties()

The long name "getCurrentProperties" was chosen because the call is
relatively expensive (if you have tens of properties to interpolate) so
it is better to call it once per frame so the properties are not
calculated more than once.

The avalaible API is:

    local tweener = require "tweener.base"
    local easing = require "tweener.easing"

    local ts = tweener("forward")

    ts.getCurrentProperties() --> Returns the table of properties
    ts.add({x=1})             --> add a tween. Accepts a duration, an easing function and a table in any order, returns a tween
    ts.remove(1)              --> Remove a tween, call with an index or a tween object.
    ts.getLength()            --> The current number of tweens.
    ts.getElapsed()           --> The elapsed time in current tween.
    ts.setCurrent(1)          --> Call with a tween or an index to set which is the current tween.
    ts.getCurrent()           --> Returns the current tween.
    ts.getNext()              --> Gets the next tween according to the current animation mode.
    ts.setMode("forward")     --> Changes the mode to the given one (string with name of the mode)
    ts.getMode()              --> Returns the name of the current mode.
    ts.udpate(elapsed)        --> update the elapsed time in current tween.
    ts.eachTween()            --> iterator that returns each tween with its index.

Finally, tween objects are just tables which store three things: the
duration of the tween, the easing function and the table of properties.
When the tweener is about to enter a tween it uses his easing function
to interpolate the values.

An example of how to use a single tween is how you can change the
interpolation function of all of them after their creation:

    local ts = tweener("forward")

    ts.add(1, { x = 1 }, easing.inOutCirc)
    ts.add(1, { x = 1 }, easing.inOutCirc)

    local tween = ts.add(1, { x = 1 }, easing.inOutCirc)

    print(tween.d) --> duration
    print(tween.f) --> easing function
    print(tween.p) --> properties

    -- switch all tweens to linear easing
    for _, t in ts.eachTween() do t.f = easing.linear end

Examples
========

There is a plain lua example and two interactive ones based on the [LÖVE](http://love2d.org)
game library. To run the examples you'll need to get the engine from
[http://love2d.org](http://love2d.org). Once you have the love executable, move into the
root directory of the library and run:

* "love examples/love/simple"
* "love examples/love/size_and_pos"

![LÖVE running a tweener example](https://github.com/EmmanuelOga/tweener/raw/master/doc/tweener-love.png "tweener on LÖVE")

Running Tests
=============

To run the tests you'll need [https://github.com/norman/telescope](telescope).
From the library's root directory, run:

    ▸ tsc tests/tweener_test.lua
    27 tests 27 passed 111 assertions 0 failed 0 errors 0 unassertive 0 pending

TODO
====

* luadocs
* inOutElastic easing works weird in one of the examples

Author
======

Emmanuel Oga 2010

License
=======

MIT
