local tCrabs = {}

function loadInput()
    --[[ get path ]]
    local sPath = shell.getRunningProgram():reverse()
    sPath = sPath:sub(({sPath:find('/')})[1]):reverse()
    --[[ get input ]]
    local file = fs.open(sPath.."/input.txt", 'r')
    local sInput = file.readAll()
    tCrabs = textutils.unserialise( '{'..sInput..'}' )
    file.close()
end

function findCheapestPos(tCrabs, bRealCalculatoin)
    local tResult = {}
    table.sort(tCrabs,function(a,b) return a>b end)
    for i=0,tCrabs[1] do
        tResult[i+1] = {["pos"]=i,["fuel"]=0}
        for _,crabPos in pairs(tCrabs) do
            local nFuel = 0
            if bRealCalculatoin then
                --[[ Part 2 (extremely inefficient) ]]
                for j=1,math.abs(crabPos-i) do
                    nFuel = nFuel+j
                end
            else
                nFuel = math.abs(crabPos-i) --[[ Part 1 ]]
            end
            tResult[i+1].fuel = tResult[i+1].fuel + nFuel
        end
    end
    table.sort(tResult,function(a,b) return a.fuel<b.fuel end)
    return "Best pos: "..tResult[1].pos..";  Fuel cost: "..tResult[1].fuel
end

loadInput()
print(
    "1. | "..findCheapestPos(tCrabs)..'\n'..
    "2. | "..findCheapestPos(tCrabs, true)
)