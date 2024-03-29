local input = io.open("./input.txt", 'r')

if type(input) == "nil" then
    error("Couldn't load file.")
end


local nTimeBegin = os.clock()

local tStacks,tStacks9001 = {},{}


---May I introduce to you? The deep clone 9001 inator!
---It clones a table, so that from one, two different,
---with the same values are present! (Doofenshmirtz would be proud of me.)
---@param original table The table to be cloned.
---@return table clone The "new" table.
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

---Convert given line into crates, stored in stacks.
---@param line string e.g. "[F]     [G] [H] (...)"
local function parseStackLine(line)
    for i=2,#line,4 do
        local index = (i+2)/4
        if type(tStacks[index]) ~= "table" then
            tStacks[index] = {}
        end

        local crate = line:sub(i,i)

        if crate ~= ' ' then
            table.insert(tStacks[index], 1, crate)
        end
    end
end

---Executes a given move command within the stacks.
---@param line string The command (e.g. "move 3 from 1 to 5")
local function moveCommand(line)
    -- Wanted: quantity, from & to
    line = line:sub(6)
    local endNum = line:find(' ')

    -- How many crates?
    local quantity = tonumber(line:sub(1,endNum-1))
    
    line = line:sub(endNum+6)
    endNum = line:find(' ')

    -- Get Stack IDs
    local from = tonumber(line:sub(1,endNum-1))
    local to = tonumber(line:sub(endNum+4))

    -- Execute
    local tCrates = {}
    for _=1,quantity do
        -- Get crates that will be moved
        local sCrate = tStacks[from][#tStacks[from]]
        table.insert(tCrates, 1, tStacks9001[from][#tStacks9001[from]])
        -- Remove crates from original stack
        tStacks[from][#tStacks[from]] = nil
        tStacks9001[from][#tStacks9001[from]] = nil

        -- Part 1
        table.insert(tStacks[to], sCrate)
    end

    -- Part 2
    for _,sCrate in pairs(tCrates) do
        table.insert(tStacks9001[to], sCrate)
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


-- Genearte output string
for i=1,#tStacks do
    scoreP1 = scoreP1..tStacks[i][#tStacks[i]]
    scoreP2 = scoreP2..tStacks9001[i][#tStacks9001[i]]
end

local nTimeEnd = os.clock()

print("Crates on top of each stack: "..scoreP1)
print("This time with the CrateMover 9001: "..scoreP2)
print("Time: "..tostring((nTimeEnd-nTimeBegin)*1000000).."µs")