local tSegments = {}


function loadInput()
    --[[ get path ]]
    local sPath = shell.getRunningProgram():reverse()
    sPath = sPath:sub(({sPath:find('/')})[1]):reverse()
    --[[ get input ]]
    local file = fs.open(sPath.."/input.txt", 'r')
    local sLine = file.readLine()
    while type(sLine) ~= "nil" do
        local sPatterns = sLine:sub(1, ({sLine:find('|')})[1]-1)
        local sValues = sLine:sub(({sLine:find('|')})[1]+1)
        tSegments[#tSegments+1] = {["patterns"]={},["values"]={}}
        for sSegments in string.gmatch(sValues, "%a+") do
            local nLength = #tSegments[#tSegments].values
            tSegments[#tSegments].values[nLength+1] = sSegments
        end
        for sSegments in string.gmatch(sPatterns, "%a+") do
            local nLength = #tSegments[#tSegments].patterns
            tSegments[#tSegments].patterns[nLength+1] = sSegments
        end
        sLine = file.readLine()
    end
    file.close()
end

function countEasyOnes()
    local nCounter = 0
    for _,tDisplay in pairs(tSegments) do
        for _,sSegment in pairs(tDisplay.values) do
            if #sSegment == 2
            or #sSegment == 4
            or #sSegment == 3
            or #sSegment == 7 then
                nCounter = nCounter+1
            end
        end
    end
    return nCounter
end

local tKnown = {}
function updateKnown(tSegments)
    tKnown = {}
    for _,sSegment in pairs(tSegments) do
        if #sSegment == 2 then
            --sNumber = sNumber..'1'
            tKnown[sSegment:sub(1,1)] = 'c'
            tKnown[sSegment:sub(2,2)] = 'f'
        elseif #sSegment == 4 then
            --sNumber = sNumber..'4'
            tKnown[sSegment:sub(1,1)] = 'b'
            tKnown[sSegment:sub(2,2)] = 'd'
            tKnown[sSegment:sub(3,3)] = 'c'
            tKnown[sSegment:sub(4,4)] = 'f'
        end
    end
end

--[[ DOESNT WORK TO 100%!!! ]]
function decode(sSegments)
    local tFound = {}
    if #sSegments == 5 then
        for i=1,5 do
            local var = tKnown[sSegments:sub(i,i)]
            if var then
                tFound[var] = true
            end
        end
        if tFound['b'] and tFound['f'] and not tFound['c'] then
            return '5'
        elseif tFound['e'] and not tFound['f'] then
            return '2'
        elseif tFound['b'] and not tFound['e'] then
            return '3'
        end
    elseif #sSegments == 6 then
        for i=1,6 do
            local var = tKnown[sSegments:sub(i,i)]
            if var then
                tFound[var] = true
            end
        end
        if not tFound['c'] then
            return '6'
        elseif tFound['e'] and not tFound['d'] then
            return '0'
        else
            return '9'
        end
    end
    return "_"
end

function getAllValues()
    local nResult = 0
    for _,tDisplay in pairs(tSegments) do
        local sNumber = ""
        for nIndex,sSegment in pairs(tDisplay.values) do
            if #sSegment == 2 then
                sNumber = sNumber..'1'
            elseif #sSegment == 4 then
                sNumber = sNumber..'4'
            elseif #sSegment == 3 then
                sNumber = sNumber..'7'
            elseif #sSegment == 7 then
                sNumber = sNumber..'8'
            else
                updateKnown(tDisplay.patterns)
                sNumber = sNumber..decode(sSegment)
            end
        end
        if sNumber:find('_') then
            term.setTextColor(colors.red)
        else
            term.setTextColor(colors.white)
            nResult = nResult+tonumber(sNumber)
        end
        print(sNumber)
    end
    return nResult
end

loadInput()
print(
    "----\n"..
    "1. "..countEasyOnes()..'\n'..
    "2. "..getAllValues()
)