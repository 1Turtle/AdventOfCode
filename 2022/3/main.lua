local input = io.open("./input.txt", 'r')

if type(input) == "nil" then
    error("Couldn't load file.")
end


---Converts a given compartment to a table with its content.
---@param compartment string Represented by its content, which is a char from a-z or A-Z.
---@return table items The content. Using an item as a key will return whenever it exists or not.
local function getItems(compartment)
    local itemlist = {}
    
    for i=1,#compartment do
        local item = compartment:sub(i,i)
        itemlist[item] = true
    end

    return itemlist
end

---Returns the item that exists in every half OR the badge that the three given group members have.
---@param left table First half of a rucksack OR first group member, if there is a condition too.
---@param right table Second half of a rucksack OR second groupo member, if there is a condition too.
---@param condition table? third group member.
---@return string Returns item that exists twice. Or if condition given, returns item that represents the badge.
local function getSpecialItem(left, right, condition)
    for item,_ in pairs(left) do
        if right[item] then
            if condition then
                if condition[item] then
                    return item
                end
            else
                return item
            end
        end
    end
    error("Wait..")
end

---Converts a given item to its priority number.
---@param char string The item.
---@return number priority The priority of the given item.
local function getPoints(char)
    char = char:byte()
    if char > 96 and char < 123 then -- Range: a-z (67-122)
        return char-96
    elseif char > 64 and char < 91 then -- Range: A-Z (65-92)
        return char-38
    end
end


local scoreP1,scoreP2 = 0,0
local group = {}

for line in input:lines() do
    --[[ Part 1 ]]
    local left,right = "",""  -- Compartments

    left = getItems( line:sub(1,#line/2) )
    right = getItems( line:sub(#line/2+1) )

    -- Get item that exists twice and convert to priority, for end result.
    local special = getSpecialItem(left, right)
    scoreP1 = scoreP1 + getPoints(special)


    --[[ Part 2 ]]
    table.insert(group, getItems(line) )
    if #group > 2 then
        -- Get badge of the current group and convert to item priority for end result.
        special = getSpecialItem(group[1], group[2], group[3])
        scoreP2 = scoreP2 + getPoints(special)

        group = {}
    end
end

input:close()


print("Sum of priorities: "..scoreP1)
print("Sum of corresponding badges: "..scoreP2)