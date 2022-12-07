local input = io.open("/home/sammy/Dokumente/adventofcode/2022/7/input.txt", 'r')

if type(input) == "nil" then
    error("Couldn't load file.")
end


local nTimeBegin = os.clock()

local tNotLuaFileSystem = {}
local tCurPath,bReadList = {},false
local nTOTAL_SPACE =    70000000
local nREQUIRED_SPACE = 30000000

---Returns the table, representing the dir the current path is pointing at.
---@return table dir Table of current directory.
local function getCurDir()
    local cur = tNotLuaFileSystem
    -- Dig further towards the wanted folder and create new ones if they dont exist yet
    for _,dir in pairs(tCurPath) do
        if not cur[dir] then
            cur[dir] = {}
        end
        cur = cur[dir]
    end

    return cur
end

---Returns a table with the args.
---@param sCMD string The command.
---@return table tArgs The args from the given command.
local function separateArgs(sCMD)
    local tArgs = {}
    for arg in sCMD:gmatch("[^%s]+") do
        tArgs[#tArgs+1] = arg
    end
    return tArgs
end

local cmd = {}

---Changes current path, relatively from the current path (yes).
---@param _? string The name of the command.
---@param dir string The folder to go into (or go one layer back via "..")
function cmd.cd(_, dir)
    -- Adjust path
    if dir == ".." then
        tCurPath[#tCurPath] = nil
    elseif dir ~= "/" then
        tCurPath[#tCurPath+1] = dir
    end

    -- Generate structure
    getCurDir()
end

---Normally prints a list of the current dir, but here we reverse engineer it:
---Insert items (files or folders) in current dir by given sCMD.
---If sCMD is "ls", it sets mode into reading, which starts geting the actual
---Instructions for the next times.
---@param sCMD string The command ("ls") or a output of that command (e.g. "12305 test.txt")
function cmd.ls(sCMD)
    bReadList = true
    if sCMD == "ls" then return end

    local dir = getCurDir()
    local tArgs = separateArgs(sCMD)
    -- Create dir or add file with size
    if tArgs[1] == "dir" then
        dir[tArgs[2]] = {}
    else
        dir[tArgs[2]] = tonumber(tArgs[1]) or 0
    end
end

---Executes a given command. (aka "cd" or "ls")
---@param sCMD string The command.
function cmd.execute(sCMD)
    local tArgs = separateArgs(sCMD)

    bReadList = false
    if cmd[tArgs[1]] then
        cmd[tArgs[1]]( table.unpack(tArgs) )
    else
        error("Unknown command: \'"..tArgs[1].."\'")
    end
end


-- Main loop to generate the FileSystem
for line in input:lines() do
    if line:find('$ ') then
        cmd.execute(line:sub(3))
    elseif bReadList then
        cmd.ls(line)
    end
end

input:close()


local scoreP1 = 0
---Sets and returns the size of the given Folder. Is recursive to get it precicely!
---@param dir table Represents a folder.
---@return number The size of the given folder. (Will also be reachable by dir["__SIZE"] after this func.)
local function getDirSize(dir)
    local size = 0

    for name,typ in pairs(dir) do
        local tmp = 0
        if type(typ) == "number" then
            tmp = typ
        else
            tmp = getDirSize(dir[name])
            -- Generate total size for part 1
            if tmp <= 100000 then
                scoreP1 = scoreP1 + tmp
            end
        end

        size = size + tmp
    end

    dir["__SIZE"] = size
    return size
end

getDirSize(tNotLuaFileSystem)

local scoreP2 = {tNotLuaFileSystem["__SIZE"]}
local nUnused = nTOTAL_SPACE-tNotLuaFileSystem["__SIZE"]

---Needed for part 2, returns the smallest dir that is enough to get enough space. (Also recursive!)
---@param dir table Represents a folder to start at.
local function getDirThatShouldBeDeleted(dir)
    for _,dir in pairs(dir) do
        if type(dir) == "table" then
            getDirThatShouldBeDeleted(dir)
            if nUnused+dir["__SIZE"] >= nREQUIRED_SPACE then
                scoreP2[#scoreP2+1] = dir["__SIZE"]
            end
        end
    end
end

getDirThatShouldBeDeleted(tNotLuaFileSystem)

table.sort(scoreP2)
scoreP2 = scoreP2[1]


local nTimeEnd = os.clock()

print("Part 1: "..scoreP1)
print("Part 2: "..scoreP2)
print("Time: "..tostring((nTimeEnd-nTimeBegin)*1000000).."µs")