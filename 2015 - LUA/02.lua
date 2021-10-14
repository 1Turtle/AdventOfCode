local sInputPath = "./.02.table"

local nX,nY = term.getCursorPos()
local tArgs = { ... }
local bPartTwo = (tArgs[1] == "2")
local nTotalSize = 0

--[[ Get right path ]]
if sInputPath:sub(1,2) == "./" then
    local sPath = shell.getRunningProgram():reverse()
    sPath = sPath:sub(({sPath:find('/')})[1]):reverse()
    sInputPath = sPath..sInputPath:sub(3)
end


local function getSize(sGift)
    local tNumbers,nPos = { "0","0","0" },1
    for i=1,#sGift+1 do
        if sGift:sub(i,i):match('%d') then
            tNumbers[nPos] = tNumbers[nPos]..sGift:sub(i,i)
        else
            tNumbers[nPos] = tonumber(tNumbers[nPos])
            nPos = nPos+1
        end
    end
    return table.unpack(tNumbers)
end

local function customizeSizes(nL,nW,nH)
    if not bPartTwo then
        nL, nW, nH = 2*nL*nW, 2*nW*nH, 2*nH*nL
    end
    local tSorted = {nL,nW,nH}
    table.sort(tSorted, function(a,b)
        return a < b
    end)
    if bPartTwo then
        return 2*tSorted[1] + 2*tSorted[2] + (nL*nW*nH)
    else
        return nL + nW + nH + (tSorted[1]/2)
    end
end

local file = fs.open(sInputPath, 'r')
local sLine = file.readLine()
while type(sLine) ~= "nil" do
    --[[ c a l c u l a t e ]]
    local nRequiredSize = customizeSizes(getSize(sLine))
    nTotalSize = nTotalSize + nRequiredSize
    --[[ Print progress ]]
    term.setCursorPos(nX,nY)
    term.clearLine()
    term.write(sLine.." => "..nRequiredSize)
    sLine = file.readLine()
    sleep()
end
file.close()
term.setCursorPos(nX,nY)
term.clearLine()
print("DONE")
term.setCursorPos(nX,nY+1)
print("The required amount is: "..nTotalSize.." feet!")