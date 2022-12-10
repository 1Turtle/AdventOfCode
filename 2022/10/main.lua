local input = io.open("./input.txt", 'r')

if type(input) == "nil" then
    error("Couldn't load file.")
end


local scoreP1,scoreP2 = 0,{}
local xReg,cycle = 1,0
local function doCycle()
    -- Part 2
    local xPos = cycle%40
    if xPos >= xReg-1 and xPos <= xReg+1 then
        scoreP2[cycle] = true
    end
    cycle = cycle+1
    -- Part 1
    local check = (cycle-20)/40
    if math.floor(check) == check then
        scoreP1 = scoreP1+cycle*xReg
    end
end


local nTimeBegin = os.clock()
for line in input:lines() do
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

local nTimeEnd = os.clock()
input:close()


print("Total signal strength: "..scoreP1)
print("Received image: ")

local width,height = 40,6
local line = ""
for i=0,width*height do
    line = line..(scoreP2[i] and '#' or '.')
    if #line >= width then
        print(line)
        line = ""
    end
end

print("Time: "..tostring((nTimeEnd-nTimeBegin)*1000000).."µs")