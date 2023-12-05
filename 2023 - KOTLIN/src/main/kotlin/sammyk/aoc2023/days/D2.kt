package sammyk.aoc2023.days

import java.lang.IllegalArgumentException

fun main() {
    D2().solve()
}

class D2 : Day(2) {

    override fun part1(puzzle: List<String>): Int {
        var valids = 0

        val redLimit = 12; val greenLimit = 13; val blueLimit = 14
        val colors = mapOf(Regex("(\\d+) red") to redLimit, Regex("(\\d+) green") to greenLimit, Regex("(\\d+) blue") to blueLimit)

        for ((index, line) in puzzle.withIndex()) {
            var isValid = true

            for ((regex, limit) in colors)
                for (field in regex.findAll(line))
                    if (field.groupValues[1].toInt() > limit) {
                        isValid = false
                        break
                    }

            if (!isValid) continue

            val gameTemplate = Regex("Game (\\d+)")
            valids += gameTemplate.find(line)?.groupValues?.get(1)?.toInt()
                ?: throw IllegalArgumentException("Line $index from the given puzzle input is invalid")
        }
        return valids
    }

    override fun part2(puzzle: List<String>): Int {
        var sum = 0

        val colors = listOf(
            Regex("(\\d+) red"),
            Regex("(\\d+) green"),
            Regex("(\\d+) blue")
        )

        for (line in puzzle) {
            val limits = mutableListOf(0, 0, 0)

            for ((id, regex) in colors.withIndex())
                for (field in regex.findAll(line)) {
                    val cur = field.groupValues[1].toInt()
                    if (cur > limits[id])
                        limits[id] = cur
                }

            sum += (limits[0] * limits[1] * limits[2])
        }

        return sum
    }
}