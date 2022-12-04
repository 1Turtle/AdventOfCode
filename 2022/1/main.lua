local input = io.open("./input.txt", 'r')

if type(input) == "nil" then
    error("Couldn't load file.")
end


local elfes = {0}
local index = 1

-- Load file into table
for line in input:lines() do
    if #line >= 1 then
        elfes[index] = elfes[index] + (tonumber(line) or 0)
    else
        index = index+1
        elfes[index] = 0
    end
end

input:close()


-- Make it useful
table.sort(elfes)

print("Top 3 elfes:")

local total = 0
for j=0,2 do
    local i = #elfes-j
    total = total + elfes[i]
    
    print((j+1)..". "..elfes[i])
end

print("Total: "..total)