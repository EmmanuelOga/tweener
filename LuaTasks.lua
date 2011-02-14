require "tlua"

local sh = os.execute

local function docs()
  sh("luadoc -d docs --nomodules columns/*.lua")
end

local function test()
  sh("~/.luarocks/bin/tsc tests/*_test.lua")
end

tlua.task("docs", "Run Luadoc for the Tlua project", docs)
tlua.task("test", "Run tests", test)
