local input = io.open("./input.txt", 'r')

if type(input) == "nil" then
    error("Couldn't load file.")
end


-- Points for round results
local rules = {
    lose = 0,
    draw = 3,
    win  = 6
}

-- Points for current hand (A-C enemy, X-Z for me)
local hand = {
    A=1, X=1, -- Rock
    B=2, Y=2, -- Paper
    C=3, Z=3, -- Scissor
}

---Calculates the score with given hands.
---Needed for Part 1
---@param enemy string Represents enemys hand with 'A','B' or 'C'
---@param me string Represents your hand with 'X','Y' or 'Z'
---@return integer result The score of this round
local function getScore(enemy, me)
    if (enemy=='A' and me=='X')
    or (enemy=='B' and me=='Y')
    or (enemy=='C' and me=='Z') then
        return rules["draw"] + hand[me]
    elseif (enemy=='A' and me=='Z')
    or (enemy=='B' and me=='X')
    or (enemy=='C' and me=='Y') then
        return rules["lose"] + hand[me]
    elseif (enemy=='A' and me=='Y')
    or (enemy=='B' and me=='Z')
    or (enemy=='C' and me=='X') then
        return rules["win"] + hand[me]
    end
    error("Bro wtf how >.>")
end

---Calculates score which given hand and expected result.
---Needed for Part 2
---@param enemy string Represents enemys hand with 'A','B' or 'C'
---@param result string Represents the expected result via 'X','Y' or 'Z'
---@return integer result The score of this round
local function getHand(enemy, result)
    if result=='X' then
        return rules["lose"]
            + (enemy=='A' and hand['Z'] or 0)
            + (enemy=='B' and hand['X'] or 0)
            + (enemy=='C' and hand['Y'] or 0)
    elseif result=='Y' then
        return rules["draw"]
            + (enemy=='A' and hand['X'] or 0)
            + (enemy=='B' and hand['Y'] or 0)
            + (enemy=='C' and hand['Z'] or 0)
    elseif result=='Z' then
        return rules["win"]
            + (enemy=='A' and hand['Y'] or 0)
            + (enemy=='B' and hand['Z'] or 0)
            + (enemy=='C' and hand['X'] or 0)
    end
    error("If it happens once, it's your fault. If it happens twice, it's my fault.")
end


local scoreP1,scoreP2 = 0,0

-- Goes through each round and calculates the scores
local line = input:read()
while line do
    local players = {"",""}
    
    -- Get each side
    local index = 1
    for hand in (line):gmatch("[^ ]") do
        players[index] = hand
        index = index+1
    end
    
    scoreP1 = scoreP1 + getScore(players[1], players[2])
    scoreP2 = scoreP2 + getHand(players[1], players[2])

    line = input:read()
end

input:close()


print("Your score would be: "..scoreP1)
print("... Oh no wait, actually I read the plan wrong,\nwhich is why your REAL score is: "..scoreP2)