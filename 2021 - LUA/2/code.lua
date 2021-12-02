local tInput = {}


function loadInput()
    --[[ get path ]]
    local sPath = shell.getRunningProgram():reverse()
    sPath = sPath:sub(({sPath:find('/')})[1]):reverse()

    local file = fs.open(sPath.."/input.txt", 'r')
    local sLine = file.readLine()
    while type(sLine) ~= "nil" do
        local nCut = sLine:find(' ')
        tInput[#tInput+1] = {
            ["command"]= sLine:sub(1,nCut-1),
            ["times"]=   tonumber(sLine:sub(nCut+1)) or 1
        }
        sLine = file.readLine()
    end
    file.close()
end


function partOne(tData)
    local pos = { ['x']=0, ['y']=0 }
    for i=1,#tData do
        if "forward" == tData[i].command then
            pos.x = pos.x + tData[i].times
        elseif "down" == tData[i].command then
            pos.y = pos.y + tData[i].times
        elseif "up" == tData[i].command then
            pos.y = pos.y - tData[i].times
        end
    end
    return pos.x * pos.y
end


function partTwo(tData)
    local pos, aim = { ['x']=0, ['y']=0 }, 0
    for i=1,#tData do
        if "forward" == tData[i].command then
            pos.x = pos.x + tData[i].times
            pos.y = pos.y + (tData[i].times * aim)
        elseif "down" == tData[i].command then
            aim = aim + tData[i].times
        elseif "up" == tData[i].command then
            aim = aim - tData[i].times
        end
    end
    return pos.x * pos.y
end


loadInput()
print(
    "1: "..partOne(tInput)
    ..'\n'..
    "2: "..partTwo(tInput)
)