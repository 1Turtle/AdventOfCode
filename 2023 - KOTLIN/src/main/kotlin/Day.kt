import kotlin.system.measureNanoTime
import kotlin.time.Duration.Companion.nanoseconds

abstract class Day(private val index: Int) {

    fun solve(): Pair<Int?, Int?>  {
        println("Solving puzzle for day $index.")

        val classLoader: ClassLoader = Thread.currentThread().contextClassLoader
        val puzzle: List<String> = classLoader.getResourceAsStream("$index.txt")
            ?.bufferedReader()
            ?.use { it.readLines() }
            ?: throw IllegalArgumentException("File '$index.txt' not found")

        val solution1: Int?
        val solution2: Int?

        val elapsed1 = measureNanoTime { solution1 = part1(puzzle) }.nanoseconds
        val elapsed2 = measureNanoTime { solution2 = part2(puzzle) }.nanoseconds

        println("""
                |Found solutions, took ${elapsed1 + elapsed2}:
                | - Part 1: ${solution1 ?: "Unknown"} (${elapsed1})
                | - Part 2: ${solution2 ?: "Unknown"} (${elapsed2})
                """.trimMargin())

        return Pair(solution1, solution2)
    }

    abstract fun part1(puzzle: List<String>): Int?

    abstract fun part2(puzzle: List<String>): Int?
}