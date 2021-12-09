local tBitmap = {}

function loadInput()
    --[[ get path ]]
    local sPath = shell.getRunningProgram():reverse()
    sPath = sPath:sub(({sPath:find('/')})[1]):reverse()
    --[[ get input ]]
    local file = fs.open(sPath.."/input.txt", 'r')
    local sLine = file.readLine()
    while type(sLine) ~= "nil" do
        tBitmap[#tBitmap+1] = sLine
        sLine = file.readLine()
    end
    file.close()
end

function getNearPoints(x,y, bPrint)
    local tBit = { ['nUp'] = 9,['nDown'] = 9,['nLeft'] = 9,['nRight'] = 9}
    tBit.nCenter = tonumber( (tBitmap[y] or ""):sub(x,x) )
    tBit.nUp = tonumber( (tBitmap[y-1] or ""):sub(x,x) ) or tBit.nUp
    tBit.nDown = tonumber( (tBitmap[y+1] or ""):sub(x,x) ) or tBit.nDown
    tBit.nLeft = tonumber( (tBitmap[y] or ""):sub(x-1,x-1) ) or tBit.nLeft
    tBit.nRight = tonumber( (tBitmap[y] or ""):sub(x+1,x+1) ) or tBit.nRight
    return tBit
end

local tLowPoints = {}
function getLowPoints()
    local nLowPoints = 0
    for y=1,#tBitmap do
        for x=1,#tBitmap[y] do
            local tBit = getNearPoints(x,y)
            if  tBit.nCenter < tBit.nUp
            and tBit.nCenter < tBit.nDown
            and tBit.nCenter < tBit.nLeft
            and tBit.nCenter < tBit.nRight then
                nLowPoints = nLowPoints+tBit.nCenter+1
                tLowPoints[#tLowPoints+1] = {['x']=x,['y']=y}
            end
        end
    end
    return  nLowPoints
end

function getBasins(tPoints, nCount)
    if not nCount then nCount = 0 end
    local tNewPoints = {}
    for _,point in pairs(tPoints) do
        local tBit = getNearPoints(point.x, point.y)
        tBitmap[point.y] = tBitmap[point.y]:sub(1,point.x-1)..'9'..tBitmap[point.y]:sub(point.x+1)
        if tBit.nUp ~= 9 then
            tNewPoints[#tNewPoints+1] = {['x']=point.x,['y']=point.y-1}
            tBitmap[point.y-1] = tBitmap[point.y-1]:sub(1,point.x-1)..'9'..tBitmap[point.y-1]:sub(point.x+1)
        end if tBit.nDown ~= 9 then
            tNewPoints[#tNewPoints+1] = {['x']=point.x,['y']=point.y+1}
            tBitmap[point.y+1] = tBitmap[point.y+1]:sub(1,point.x-1)..'9'..tBitmap[point.y+1]:sub(point.x+1)
        end if tBit.nLeft ~= 9 then
            tNewPoints[#tNewPoints+1] = {['x']=point.x-1,['y']=point.y}
            tBitmap[point.y] = tBitmap[point.y]:sub(1,point.x-2)..'9'..tBitmap[point.y]:sub(point.x)
        end if tBit.nRight ~= 9 then
            tNewPoints[#tNewPoints+1] = {['x']=point.x+1,['y']=point.y}
            tBitmap[point.y] = tBitmap[point.y]:sub(1,point.x)..'9'..tBitmap[point.y]:sub(point.x+2)
        end 
    end
    nCount = nCount+#tNewPoints
    if #tNewPoints > 0 then
        print(textutils.serialise(tNewPoints))
        io.read()
        nCount = nCount+getBasins(tNewPoints, nCount)
    end
    return nCount
end

local tCount = {}
function getAllBasins(tPoints)
    for _,point in pairs(tPoints) do
        tCount[#tCount+1] = getBasins({point})
        print("------------")
    end
    return textutils.serialise(tCount)
end

loadInput()

print(
    "1. "..getLowPoints()..'\n'..
    "2. "..getAllBasins(tLowPoints)
)