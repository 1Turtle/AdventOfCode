local tData = {}
local tCrossed = { 0,0 }

local grid,advancedGrid = {},{}
local width,height = 0,0

function string.split(str, splitter)
    local nEnd1,nStart2 = str:find(splitter)
    
    local sLeft = str:sub(1,nEnd1-#splitter+1):gsub(splitter, "")
    local sRight = str:sub(nStart2+1)
    
    return sLeft, sRight
end

function convertData(sLine)
    local tPos = {{['x']=0,['y']=0}, {['x']=0,['y']=0}}
    local sLine1,sLine2 = sLine:split(" -> ")
    
    for i,sSubLine in pairs({sLine1,sLine2}) do
        tPos[i].x,tPos[i].y = sSubLine:split(',')
        
        tPos[i].x = tonumber(tPos[i].x)
        tPos[i].y = tonumber(tPos[i].y)
        --[[ Set space ]]
        if tPos[i].x+1 > width then
            width = tPos[i].x+1
        end
        if tPos[i].y+1 > height then
            height = tPos[i].y+1
        end
    end

    return {['x1']=tPos[1].x,['y1']=tPos[1].y,['x2']=tPos[2].x,['y2']=tPos[2].y}
end

function loadInput()
    --[[ get path ]]
    local sPath = shell.getRunningProgram():reverse()
    sPath = sPath:sub(({sPath:find('/')})[1]):reverse()

    local file = fs.open(sPath.."/input.txt", 'r')
    local sLine = file.readLine()
    while type(sLine) ~= "nil" do
        tData[#tData+1] = convertData(sLine)
        sLine = file.readLine()
    end
    file.close()
end

--[[ Digital differential analyzer ]]
function lineCalculator(x1,y1, x2,y2, grid, part)
    local x,y
    local step

    local dx = x2-x1
    local dy = y2-y1
    if math.abs(dx) >= math.abs(dy) then
        step = math.abs(dx)
    else
        step = math.abs(dy)
    end
    dx = dx/step
    dy = dy/step
    local x,y = x1,y1
    for i=1,step+1 do
        if not grid[y] then
            grid[y] = {}
        end
        if not grid[y][x] then
            grid[y][x] = 0
        end
        grid[y][x] = grid[y][x]+1
        if grid[y][x] == 2 then
            tCrossed[part] = tCrossed[part]+1
        end
        x = x+dx
        y = y+dy
        i = i+1
    end
end

function drawLines()
    for _,line in pairs(tData) do
        if ((line.x1 == line.x2) or (line.y1 == line.y2)) then
            lineCalculator(line.x1,line.y1, line.x2,line.y2, grid,1)
            lineCalculator(line.x1,line.y1, line.x2,line.y2, advancedGrid,2)
        else
            lineCalculator(line.x1,line.y1, line.x2,line.y2, advancedGrid,2)
        end
    end
end

loadInput()
--[[ create grid ]]
for _,subGrid in pairs({grid,advancedGrid}) do
    for y=1,height do
        subGrid[y] = {}
        for x=1,width do
            subGrid[y][x] = 0
        end
    end
end
drawLines()
print(
    "1: "..tCrossed[1]..'\n'..
    "2: "..tCrossed[2]
)