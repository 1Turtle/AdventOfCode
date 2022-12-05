local input = io.open("/home/sammy/Dokumente/adventofcode/2022/5/input.txt", 'r')

if type(input) == "nil" then
    error("Couldn't load file.")
end

local nTimeBegin = os.clock()

local tStacks,tStacks9001 = {},{}


local function deepClone9001(original)
    local copy = {}
    for k,v in pairs(original) do
        if type(v) == "table" then
            v = deepClone9001(v)
        end
        copy[k] = v
    end
    return copy
end

local function parseStackLine(line)
    for i=2,#line,4 do
        local index = (i+2)/4
        if type(tStacks[index]) ~= "table" then
            tStacks[index] = {}
        end

        local box = line:sub(i,i)

        if box ~= ' ' then
            table.insert(tStacks[index], 1, box)
        end
    end
end

local function moveCommand(line)
    -- Wanted: quantity, from & to
    line = line:sub(6)
    local endNum = line:find(' ')

    local quantity = tonumber(line:sub(1,endNum-1))
    
    line = line:sub(endNum+6)
    endNum = line:find(' ')

    local from = tonumber(line:sub(1,endNum-1))
    local to = tonumber(line:sub(endNum+4))

    -- Execute
    local boxes = {}
    for i=1,quantity do
        local box = tStacks[from][#tStacks[from]]
        table.insert(boxes, 1, tStacks9001[from][#tStacks9001[from]])
        tStacks[from][#tStacks[from]] = nil
        tStacks9001[from][#tStacks9001[from]] = nil

        -- Part 1
        table.insert(tStacks[to], box)
    end

    -- Part 2
    for _,box in pairs(boxes) do
        table.insert(tStacks9001[to], box)
    end
end


local scoreP1,scoreP2 = "",""

local bLoadStack = true
for line in input:lines() do
    -- Skippable lines
    if #line < 2 or (bLoadStack and not line:find('%[')) then
        tStacks9001 = deepClone9001(tStacks)
        bLoadStack = false
        goto skip
    end

    if bLoadStack then
        parseStackLine(line)
    else
        moveCommand(line)
    end    

    :: skip ::
end

input:close()

for i=1,#tStacks do
    scoreP1 = scoreP1..tStacks[i][#tStacks[i]]
end
for i=1,#tStacks9001 do
    scoreP2 = scoreP2..tStacks9001[i][#tStacks9001[i]]
end

local nTimeEnd = os.clock()

print("Crates on top of each stack: "..scoreP1)
print("This time with the CrateMover 9001: "..scoreP2)
print("Time: "..tostring((nTimeEnd-nTimeBegin)*1000000).."µs")