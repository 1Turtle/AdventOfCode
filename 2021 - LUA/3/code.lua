local tInput = {}


function loadInput()
    --[[ get path ]]
    local sPath = shell.getRunningProgram():reverse()
    sPath = sPath:sub(({sPath:find('/')})[1]):reverse()

    local file = fs.open(sPath.."/input.txt", 'r')
    local sLine = file.readLine()
    while type(sLine) ~= "nil" do
        local nCut = sLine:find(' ')
        tInput[#tInput+1] = sLine
        sLine = file.readLine()
    end
    file.close()
end


local tCounter
function partOne(tData)
    --[[ Count bits ]]
    tCounter = { }
    for i=1,#tData[1] do tCounter[i] = {0,0} end
    for _,value in pairs(tData) do
        for i=1,#value do
            local sType = tonumber(value:sub(i,i))+1
            tCounter[i][sType] = tCounter[i][sType]+1
        end
    end
    --[[ Calculate gamma rate ]]
    local sGamma = ""
    local sEpsilon = ""
    for nColumn,tResult in pairs(tCounter) do
        local numG,numE = '1','0'
        if tResult[1] > tResult[2] then
            numG = '0'
            numE = '1'
        end
        sGamma = sGamma .. numG
        sEpsilon = sEpsilon .. numE
    end
    return tonumber(sGamma,2) * tonumber(sEpsilon,2)
end

function table.shallow_copy(t)
    local t2 = {}
    for k,v in pairs(t) do
      t2[k] = v
    end
    return t2
  end

function partTwo(tData)
    local tList = { ["oxygen"]=table.shallow_copy(tData),
                    ["co2"]=table.shallow_copy(tData)
    }
    --[[ Runs loop for oxygen & co2 ]]
    for type=1,2 do
        for nPos=1,#tCounter do
            local tCurrentList = tList.co2
            if type==1 then
                tCurrentList = tList.oxygen
            end
            partOne(tCurrentList)
            local tBits = {'1','0','0','1'}
            local bit = tBits[type]
            if tCounter[nPos][1] > tCounter[nPos][2] then
                bit = tBits[type*2]
            end
            --[[ filter value for Oxygen/CO2 ]]
            local i = 1
            while i <= #tCurrentList do
                if tCurrentList[i]:sub(nPos,nPos) ~= bit then
                    if #tCurrentList == 1 then break end
                    table.remove(tCurrentList,i)
                else i=i+1 end
            end
        end
    end
    return tonumber(tList.oxygen[1],2) * tonumber(tList.co2[1],2)
end


loadInput()
print(
    "1: "..partOne(tInput)
    ..'\n'..
    "2: "..partTwo(tInput)
)