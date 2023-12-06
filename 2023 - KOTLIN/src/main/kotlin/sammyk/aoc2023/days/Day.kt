package sammyk.aoc2023.days

import kotlin.time.measureTimedValue

sealed class Day(private val index: Short) {

    fun solve(): Pair<Number?, Number?>  {
        println("Solving puzzle for day $index.")

        val classLoader: ClassLoader = Thread.currentThread().contextClassLoader
        val puzzle: List<String> = classLoader.getResourceAsStream("$index.txt")
            ?.bufferedReader()
            ?.use { it.readLines() }
            ?: throw IllegalArgumentException("File '$index.txt' not found")

        val (solution1, elapsed1) = measureTimedValue { part1(puzzle) }
        val (solution2, elapsed2) = measureTimedValue { part2(puzzle) }

        println("""
                |Found solutions, took ${elapsed1 + elapsed2}:
                | - Part 1: ${solution1 ?: "Unknown"} (${elapsed1})
                | - Part 2: ${solution2 ?: "Unknown"} (${elapsed2})
                """.trimMargin())

        return Pair(solution1, solution2)
    }

    abstract fun part1(puzzle: List<String>): Number?

    abstract fun part2(puzzle: List<String>): Number?
}