local input = io.open("./input.txt", 'r')

if type(input) == "nil" then
    error("Couldn't load file.")
end

local nTimeBegin = os.clock()


local line = input:read('l')
input:close()

---Searches for the last char, followed by [len] others that are all different on each other.
---@param input string The input where the position has to be found.
---@param len number How long that packet has to be.
---@return integer pos The last position after the [len] chars.
local function getPacketOfXX(input,len)
    local pos = -1

    -- Start at end of first potential pack 
    for i=len,#line do
        local pack = line:sub(i-len+1,i)
        local seen = {}
    
        -- Check if pack is under conditoins or not
        for j=1, #pack do
            local char = pack:sub(j,j)
    
            if seen[char] then
                goto skip
            else
                seen[char] = true
            end
        end

        pos = i
        break
    
        :: skip ::
    end

    return pos
end

local scoreP1 = getPacketOfXX(line, 4)
local scoreP2 = getPacketOfXX(line, 14)


local nTimeEnd = os.clock()

print("Start-of-packet: "..scoreP1)
print("Start-of-message: "..scoreP2)
print("Time: "..tostring((nTimeEnd-nTimeBegin)*1000000).."µs")