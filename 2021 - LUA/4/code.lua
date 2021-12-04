local tBoards = {}
local tNumbers


local nBoardDimension = 5
local nFieldColumn = 0
function createBoard(sLine)
    nFieldColumn = nFieldColumn+1
    --[[ Create new board when line is empty ]]
    if #sLine < 2 then
        tBoards[#tBoards+1] = { {},{},{},{},{} }
        nFieldColumn = 0
        return
    end
    --[[ Add row ]]
    for i=1,nBoardDimension do
        tBoards[#tBoards][nFieldColumn][i] = tonumber( sLine:sub(i*2+i-2, i*2+i-1) )
    end
end

function loadInput()
    --[[ get path ]]
    local sPath = shell.getRunningProgram():reverse()
    sPath = sPath:sub(({sPath:find('/')})[1]):reverse()

    local file = fs.open(sPath.."/input.txt", 'r')
    local sLine = file.readLine()
    while type(sLine) ~= "nil" do
        --[[  load numbers ]]
        if not tNumbers then
            tNumbers = textutils.unserialise("{"..sLine.."}")
        else
            createBoard(sLine)
        end
        sLine = file.readLine()
    end
    file.close()
end

local tWinnersBoards = {}
function markWinner(nField)
    local bAdd = true
    for _,index in pairs(tWinnersBoards) do
        if index == nField then
            bAdd = false
            break
        end
    end
    if bAdd then
        tWinnersBoards[#tWinnersBoards+1] = nField
    end
end

function winner(nIndex)
    for _,field in pairs(tWinnersBoards) do
        if nIndex == field then
            return true
        end
    end
    return false
end

local lastCalledNumFirst = -1
local lastCalledNum = -1
function calculation()
    for currentNum=1,#tNumbers do
        --[[ Mark fields for every board ]]
        for nIndex,board in pairs(tBoards) do
            local latestChanges = { {},{},{},{},{} }
            local nWinstreakColumn = {0,0,0,0,0}
            for i=1,nBoardDimension do
                if not winner(nIndex) then
                    local nWinstreak = 0
                    for j=1,nBoardDimension do
                        --[[ m a r k i n g ]]
                        if board[i][j] == tNumbers[currentNum] then
                            latestChanges[i][j] = board[i][j]
                            board[i][j] = -1
                        --[[ count marks ]]
                        elseif board[i][j] == -1 then
                            nWinstreak = nWinstreak+1
                            nWinstreakColumn[j] = nWinstreakColumn[j]+1
                        end
                    end
                    --[[ (ROW) Is board winner? ]]
                    if nWinstreak == nBoardDimension then
                        if lastCalledNumFirst == -1 then
                            lastCalledNumFirst = lastCalledNum
                        end
                        markWinner(nIndex)
                        if #tWinnersBoards == #tBoards then
                            --[[ Undo last change for part 2 ]]
                            for i=1,nBoardDimension do
                                for j=1,nBoardDimension do
                                    if latestChanges[i][j] then
                                        board[i][j] = latestChanges[i][j]
                                    end
                                end
                            end
                            return
                        end
                    end
                end
            end
            --[[ (COLUMN) Is board winner? ]]
            for _,wins in pairs(nWinstreakColumn) do
                if wins == nBoardDimension then
                    if lastCalledNumFirst == -1 then
                        lastCalledNumFirst = lastCalledNum
                    end
                    markWinner(nIndex)
                    if #tWinnersBoards == #tBoards then
                        --[[ Undo last change for part 2 ]]
                        for i=1,nBoardDimension do
                            for j=1,nBoardDimension do
                                if latestChanges[i][j] then
                                    board[i][j] = latestChanges[i][j]
                                end
                            end
                        end
                        return
                    end
                end
            end
        end
        lastCalledNum = currentNum
    end
end

function getResult(nBoardIndex,calledNum)
    local board = tBoards[nBoardIndex]
    local sum = 0
    for _,row in pairs(board) do
        for _,field in pairs(row) do
            if field ~= -1 then
                sum = sum+field
            end
        end
    end
    print(sum)
    return sum * tNumbers[calledNum]
end

loadInput()
calculation()
print(
    "1. | "..getResult(tWinnersBoards[1], lastCalledNumFirst).."\n"..
    "2. | "..getResult(tWinnersBoards[#tWinnersBoards], lastCalledNum)
)