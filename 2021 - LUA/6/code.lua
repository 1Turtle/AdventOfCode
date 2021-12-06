local tLantenFish = {} --Part 1
local tLantenFish2 = {} --Part 2

function convertInput(tFishes)
    local newTable = {}
    for i=0,9 do
        newTable[i] = 0
        for _,day in pairs(tFishes) do
            if day == i then
                newTable[i] = newTable[i]+1
            end
        end
    end
    return newTable
end

function loadInput()
    --[[ get path ]]
    local sPath = shell.getRunningProgram():reverse()
    sPath = sPath:sub(({sPath:find('/')})[1]):reverse()
    --[[ get input ]]
    local file = fs.open(sPath.."/input.txt", 'r')
    local sInput = file.readAll()
    tLantenFish = convertInput( textutils.unserialise( '{'..sInput..'}' ) )
    tLantenFish2 = convertInput( textutils.unserialise( '{'..sInput..'}' ) )
    file.close()
end

--[[function simulateDays(tLantenFish, nDays)
    local _,nY = term.getCursorPos() 
    for j=0, nDays do
        term.setCursorPos(1,nY)
        term.clearLine()
        term.write("Day: "..j.." | Fishes: "..#tLantenFish)
        for i=1,#tLantenFish do
            if tLantenFish[i] == 0 then
                tLantenFish[i] = 6
                tLantenFish[#tLantenFish+1] = 8
            else
                tLantenFish[i] = tLantenFish[i]-1
            end
        end
    end
    return #tLantenFish
end]]

function advancedDaySimulation(tLantenFish, nDays)
    local nCounter = 0
    for i=0,nDays-1 do
        for j=0,9 do
            if j == 0 then
                tLantenFish[9] = tLantenFish[9]+tLantenFish[0]
                tLantenFish[7] = tLantenFish[7]+tLantenFish[0]
                tLantenFish[0] = 0
            else
                tLantenFish[j-1] = tLantenFish[j-1]+tLantenFish[j]
                tLantenFish[j] = 0
            end
        end
    end

    for j=0,8 do
        nCounter = nCounter+tLantenFish[j]
    end
    return nCounter
end

loadInput()
print(
    "1. "..advancedDaySimulation(tLantenFish, 80)..'\n'..
    "2. "..advancedDaySimulation(tLantenFish2, 256)
)