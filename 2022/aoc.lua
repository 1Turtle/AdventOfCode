---------------------------------------------------
-- Powered by Lua v.5.4 and Luarocks
--
-- Sammy L. Koch © 2022 | MIT Licence
---------------------------------------------------
local lfs = require("lfs")

local sSep = package.config:sub(1,1)
local sInput = lfs.currentdir()
sInput = sInput..sSep.."input.txt"

local function getSecondLastElement(path)
    local pattern = "([^/]+)"
    local elements = {}
  
    for element in string.gmatch(path, pattern) do
      elements[#elements+1] = element
    end
  
    return elements[#elements-1]
end
local sDay = getSecondLastElement(sInput)

local aoc = {
    _PROTECT = {
        timer = {
            [0] = {},
            [1] = {},
            [2] = {}
        },
        day = sDay
    },
    result = {
        "???",
        "???"
    },
    input = io.open(sInput, 'r'),
    FLAG = {
        BITMAP = 0xF547A0CD0001
    }
}

local colors = {
    black   = 0,
    red     = 1,
    green   = 2,
    yellow  = 3,
    blue    = 4,
    magenta = 5,
    cyan    = 6,
    white   = 7,
}


---Returns a ready-to-use escape that can be included in a print func.
---@param sType string Either 'r','b','i' or 'u' for formating or something different (like "45m")
---@return string escape The escape to include in a print func.
function aoc.esc(sType)
    local tTyp = {
        r = "0m",
        b = "1m",
        i = "3m",
        u = "4m"
    }
    return "\027["..(tTyp[sType] or sType)
end

---Returns a escape that changes the foreground color.
---@param sColor string The color (aoc.colors[...])
---@return string escape The escape to include in a print func.
function aoc.setFG(sColor)
    return aoc.esc((colors[sColor]+30)..'m')
end

---Returns a escape that changes the background color.
---@param sColor string The color (aoc.colors[...])
---@return string escape The escape to include in a print func.
function aoc.setBG(sColor)
    return aoc.esc((colors[sColor]+40)..'m')
end


-- Language releated
local sLang = "en_US"
local tMsg = {
    ["en_US"] = {
        err_i_protec = "Can't access aoc's _PROTECT section!",
        err_out_of_bounce = "Given number is out of bounce! (Allowed range: %d-%d; Given: %s)",
        err_no_file = "Couldn't find the file \'%s\'!",
        out_solution = aoc.setFG("yellow")..aoc.esc('b').."Solutions for Day %s"..aoc.esc('r'),
        out_part = aoc.setFG("green")..aoc.esc('i').."Part".." %s:"..aoc.esc('r'),
        out_took = aoc.setFG("cyan")..aoc.esc('u').."Took:"..aoc.esc('r').." %s",
        out_result = aoc.setFG("red")..aoc.esc('u').."Result:"..aoc.esc('r')..aoc.esc('b').." %s"..aoc.esc('r')
    }
}

if type(aoc.input) == "nil" then
    error(tMsg[sLang].err_no_file:format(sInput))
end


---Checks if the given part is either 1 or 2
---@param nPart number The part.
---@param bBoth? boolean Whenever both is allowed as an option.
local function checkPart(nPart)
    local nNewPart = tonumber(nPart) or -1

    if not (nNewPart >= 0 and nNewPart <= 2) then
        error( (tMsg[sLang].err_out_of_bounce):format(
            0,
            2,
            nPart
        ))
end end

---Starts a timer for the given part (and general time too if not yet)
---@param nPart number Either 1 or 2.
function aoc.startTimer(...)
    local nTime = os.clock()
    for _,nPart in pairs({...}) do
        checkPart(nPart)

        aoc._PROTECT.timer[nPart].start = nTime
end end

---Stops a timer for the given part (and general time too if not yet)
---@param nPart number Either 1 or 2.
function aoc.stopTimer(...)
    local nTime = os.clock()
    for _,nPart in pairs({...}) do
        checkPart(nPart)

        aoc._PROTECT.timer[nPart].finish = nTime
end end

---Returns the mesured time for a part (or both) as a formated string.
---@param nPart number From 0 to 2. (where 0 represents both)
---@return string time The formated mesured time.
function aoc.getTime(nPart)
    checkPart(nPart)

    -- Check if the time got correctly mesured
    if type(aoc._PROTECT.timer[nPart].start) ~= "number"
    and type(aoc._PROTECT.timer[nPart].finish) ~= "number" then
        return tostring(123.45):gsub("%d", '?').."sec"
    end

    -- In microseconds (µs)
    local nTimeDif = (aoc._PROTECT.timer[nPart].finish-aoc._PROTECT.timer[nPart].start)*1000000
    local sUnit = "µs"

    -- In milliseconds (ms)
    if nTimeDif%1000 ~= nTimeDif then
        nTimeDif = nTimeDif/1000
        sUnit = "ms"
    end

    -- In seconds (sec)
    if nTimeDif%1000 ~= nTimeDif then
        nTimeDif = nTimeDif/1000
        sUnit = "sec"
    end

    return nTimeDif..sUnit
end

---Returns strings of something in more visually apealing.
---@param any any Literally anything.
---@return table result Splitted up in multible lines.
function aoc.advPrint(any)
    if type(any) == "table" then
        -- Create "Mosaic Graphics" using 
        if any._FLAG == aoc.FLAG.BITMAP then
            local tMosaic = {
                ["...."] = {'█',true},
                ["...#"] = {'▗',false},
                ["..#."] = {'▖',false},
                ["..##"] = {'▄',false},
                [".#.."] = {'▝',false},
                [".#.#"] = {'▌',true},
                [".##."] = {'▞',false},
                [".###"] = {'▘',true},
                ["#..."] = {'▘',false},
                ["#..#"] = {'▞',true},
                ["#.#."] = {'▌',false},
                ["#.##"] = {'▝',true},
                ["##.."] = {'▄',true},
                ["##.#"] = {'▖',true},
                ["###."] = {'▗',true},
                ["####"] = {'█',false},
            }
            -- Make sizes correct
            if #any[1]%2 ~= 0 then
                for key,value in pairs(any) do
                    any[key] = value..'.'
            end end
            if #any%2 ~= 0 then
                any[#any+1] = ('.'):rep(#any[1])
            end

            local function getPx(x,y)
                return any[y]:sub(x,x)
            end

            -- Converting it using unicodes
            local newAny = {}
            local yPos = 1
            local lastColor = ""
            for y=1,(#any/2) do
                for x=1,(#any[1]/2) do
                    local nX,nY = x*2-1,y*2-1
                    local tChar = tMosaic[getPx(nX,nY)..getPx(nX+1,nY)..getPx(nX,nY+1)..getPx(nX+1,nY+1)]
                    local sColor = (tChar[2] and aoc.setFG("white")..aoc.setBG("black") or aoc.setFG("black")..aoc.setBG("white"))
                    if not newAny[yPos] then
                        newAny[yPos] = ""
                    end
                    if lastColor ~= sColor then
                        newAny[yPos] = newAny[yPos]..sColor
                    end
                    newAny[yPos] = newAny[yPos]..tChar[1]
                end
                yPos = yPos+1
            end

            return newAny
        end

        -- Make it listable
        local index = 1
        for _,value in pairs(any) do
            any[index] = tostring(value)
            index = index+1
        end
        return any
    else
        return {tostring(any)}
end end

---Stores the final result for a part.
---@param nPart number Either 1 or 2.
---@param any any The result.
function aoc.setResult(nPart, any)
    checkPart(nPart)
    aoc.result[nPart] = any
end

---Prints the results
function aoc.getResults()
    aoc.input:close()
    
    local sTitle = tMsg[sLang].out_solution:format(aoc._PROTECT.day or "??")
    print(sTitle)
    print( ('▔'):rep(42) )

    print(tMsg[sLang].out_took:format( aoc.getTime(0) ))

    for i=1,2 do
        print("\n"..tMsg[sLang].out_part:format(i))
        
        local tResults = aoc.advPrint(aoc.result[i])
        print('', tMsg[sLang].out_result:format( tResults[1] ))
        table.remove(tResults,1)
        for _,line in pairs(tResults) do
            print('',aoc.esc('b'),line)
        end
            
        print(aoc.esc('r'), tMsg[sLang].out_took:format( aoc.getTime(i).."\n" ))
end end


return aoc