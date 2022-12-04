local input = io.open("./input.txt", 'r')

if type(input) == "nil" then
    error("Couldn't load file.")
end

local nTimeBegin = os.clock()


---Returns two numbers, representing a section range from X to Y
---@param assignment string The range of one half of a pair. (e.g. "2-4")
---@return number from The beginning of the range.
---@return number to The end of the range.
local function getRange(assignment)
    local split = assignment:find('-')
    
    if split then
        local from = tonumber( assignment:sub(1,split-1) ) or 0
        local to = tonumber( assignment:sub(split+1) ) or 0

        return from,to
    end
    error("Could not split given assignment.")
end

---Splits up a pair on two section ranges.
---@param pair string The pair to split. (e.g. "2-3,5-8")
---@return table leftRange The section range of the left half.
---@return table rightRange The section range of the right half.
local function getPairAssignments(pair)
    local split = pair:find(',')
    
    if split then
        local left = pair:sub(1,split-1)
        local right = pair:sub(split+1)

        left =  { getRange(left) }
        right = { getRange(right) }
        
        return left,right
    end
    error("Could not split into two assignment ranges.")
end

---Returns the FULL range of a given range. (e.g. {2,5} to {2,3,4,5})
---@param range table Given range.
---@return table fullRange the full range.
local function getFullRange(range)
    local tmp = {}
    
    for i=range[1],range[2] do
        table.insert(tmp, i)
    end

    return tmp
end

---Checks if the given ranges fully overlap eachover. 
---@param left table Left range (e.g. {2,3})
---@param right table Right right (e.g. {4,6})
---@return boolean isOverlapping Whenever all sections of one range fully exists in the other range.
local function isFullyOverlapping(left,right)
    return left[1] >= right[1] and left[2] <= right[2]
        or right[1] >= left[1] and right[2] <= left[2]
end

---Cheks if the given ranges partly overlap eachover.
---@param left table Left range (e.g. {2,3})
---@param right table Right right (e.g. {4,6})
---@return boolean isOverlapping Whenever one section exists in both ranges.
local function isOverlapping(left,right)
    left = getFullRange(left)
    right = getFullRange(right)

    -- Searching for something overlapping somewhere
    for _,vorlage in ipairs(left) do
        for _,antwort in ipairs(right) do
            if vorlage == antwort then
                return true
    end end end

   return false
end


local scoreP1,scoreP2 = 0,0

for line in input:lines() do
    local left,right = getPairAssignments(line)

    scoreP1 = scoreP1 + (isFullyOverlapping(left,right) and 1 or 0)
    scoreP2 = scoreP2 + (isOverlapping(left,right) and 1 or 0)
end

local nTimeEnd = os.clock()
input:close()


print("Pairs that fully overlap: "..scoreP1)
print("Pairs that partly overlap: "..scoreP2)
print("Time: "..tostring((nTimeEnd-nTimeBegin)*1000000).."µs")