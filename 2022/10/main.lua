package.path = package.path .. ";../?.lua"
local aoc = require("aoc")

aoc.result = {0, {}}
aoc.startTimer(0)

local xReg,cycle = 1,0
local function doCycle()
    -- Part 2
    local xPos = cycle%40
    if xPos >= xReg-1 and xPos <= xReg+1 then
        aoc.result[2][cycle] = true
    end
    cycle = cycle+1
    -- Part 1
    local check = (cycle-20)/40
    if math.floor(check) == check then
        aoc.result[1] = aoc.result[1]+cycle*xReg
    end
end


aoc.startTimer(1,2)
for line in aoc.input:lines() do
    if line:sub(1,4) == "noop" then
        doCycle()
    elseif line:sub(1,4) == "addx" then
        doCycle()
        doCycle()
        local offset = tonumber(line:sub(6))
        xReg = xReg+offset
    else
        error("Unknown command.")
    end
end

aoc.stopTimer(1)

local width,height = 40,6
local line,final = "",{}
for i=0,width*height do
    line = line..(aoc.result[2][i] and '#' or '.')
    if #line >= width then
        final[#final+1] = line
        line = ""
    end
end

aoc.stopTimer(2)
aoc.result[2] = final
aoc.result[2]._FLAG = aoc.FLAG.BITMAP
aoc.stopTimer(0)

aoc.getResults()