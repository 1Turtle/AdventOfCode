package days

import Day

fun main() {
    D3().solve()
}

class D3 : Day(3) {

    override fun part1(puzzle: List<String>): Int {
        var sum = 0

        for ((vIndex, line) in puzzle.withIndex()) {

            val matches = Regex("(\\d+)").findAll(line)

            for (num in matches) {
                val hIndex = num.range.first
                val range = hIndex..hIndex+num.value.length+1

                // Prepare needed lines
                val upper = ".${if (vIndex-1 >= 0) puzzle[vIndex-1] else ".".repeat(line.length)}.".subSequence(range).toString()
                val center= ".$line.".subSequence(range).toString()
                val lower = ".${if (vIndex+1 < puzzle.size-1) puzzle[vIndex+1] else ".".repeat(line.length)}.".subSequence(range).toString()

                val match = Regex("[^\\d.]").find(upper + center + lower)

                if (match != null && match.value.isNotEmpty())
                    sum += num.value.toInt()
            }
        }

        return sum
    }

    override fun part2(puzzle: List<String>): Int {
        var sum = 0

        val registered = mutableMapOf<String, MutableList<Int>>()

        for ((vIndex, line) in puzzle.withIndex()) {

            val matches = Regex("(\\d+)").findAll(line)

            for (num in matches) {
                val hIndex = num.range.first
                val range = hIndex..hIndex+num.value.length+1

                // Prepare needed lines
                val upper = ".${if (vIndex-1 >= 0) puzzle[vIndex-1] else ".".repeat(line.length)}.".subSequence(range).toString()
                val center = ".$line.".subSequence(range).toString()
                val lower = ".${if (vIndex+1 < puzzle.size-1) puzzle[vIndex+1] else ".".repeat(line.length)}.".subSequence(range).toString()

                val match = Regex("[^\\d.]").find(upper + center + lower)

                if (match != null && match.value == "*") {
                    val upperX = upper.indexOf('*')
                    val centerX = center.indexOf('*')
                    val lowerX = lower.indexOf('*')

                    // Determine (probably not fully correct) coordinates of star
                    val coordinates: String = if (upperX >= 0)
                        Pair(hIndex + upperX, vIndex).toString()
                    else if (centerX >= 0)
                        Pair(hIndex + centerX, vIndex + 1).toString()
                    else if (lowerX >= 0)
                        Pair(hIndex + lowerX, vIndex + 2).toString()
                    else throw UnknownError("Coordinates of symbol '*' could not be determined")

                    if (registered[coordinates] == null)
                        registered[coordinates] = mutableListOf()
                    registered[coordinates]!!.add(num.value.toInt())

                    if (registered[coordinates]!!.size == 2)
                        sum += (registered[coordinates]!![0] * registered[coordinates]!![1])
                }
            }
        }

        return sum
    }
}