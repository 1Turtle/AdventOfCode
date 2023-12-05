package sammyk.aoc2023.days

import kotlin.math.pow

fun main() {
    D4().solve()
}

class D4 : Day(4) {

    override fun part1(puzzle: List<String>): Int {
        var points = 0

        for (scratchcard in puzzle) {
            val winners = getWinnersAmount(scratchcard)

            if (winners-1 >= 0)
                points += (2.0.pow(winners - 1.0)).toInt()
        }

        return points
    }

    override fun part2(puzzle: List<String>): Int {
        var copies = 0

        val amount = mutableMapOf<Int, Int>()

        for ((index, scratchcard) in puzzle.withIndex()) {
            val cardID = index+1
            val winners = getWinnersAmount(scratchcard)

            for (offset in 1..winners) {
                val existingCopies = (amount[cardID+offset] ?: 0)
                val curInstances = (amount[cardID] ?: 0) + 1

                amount[cardID+offset] = existingCopies + curInstances
            }

            copies += (amount[cardID] ?: 0) + 1
        }

        return copies
    }

    private fun getWinnersAmount(scratchcard: String): Int {
        val numbers = Regex("(\\d+)").findAll(scratchcard.split(":")[1])
        val results = mutableMapOf<String, Int>()

        for (number in numbers)
            results[number.value] = (results[number.value] ?: 0) + 1

        var winners = 0
        for ((_, count) in results)
            if (count > 1)
                winners += count-1

        return winners
    }
}