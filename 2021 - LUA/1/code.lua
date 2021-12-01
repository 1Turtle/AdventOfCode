local tInput = {}


function loadInput()
    --[[ get path ]]
    local sPath = shell.getRunningProgram():reverse()
    sPath = sPath:sub(({sPath:find('/')})[1]):reverse()

    local file = fs.open(sPath.."/input.txt", 'r')
    local sLine = file.readLine()
    while type(sLine) ~= "nil" do
        tInput[#tInput+1] = tonumber(sLine) or 0
        sLine = file.readLine()
    end
    file.close()
end


function partOne(tData)
    local measurement = 0
    for i=2,#tData do
        if tData[i] > tData[i-1] then
            measurement = measurement+1
        end
    end
    return measurement
end


function partTwo(tData)
    local tNewData = {}
    for i=1,#tData do
        tNewData[i]   = tData[i] + (tData[i+1] or 0) + (tData[i+2] or 0)
    end
    return partOne(tNewData)
end


loadInput()
print(
    "1. | "..partOne(tInput)
    ..'\n'..
    "2. | "..partTwo(tInput)
)