package sammyk.aoc2023

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import sammyk.aoc2023.days.Day

abstract class TestDay {

    abstract val day: Day

    abstract val testPuzzle1: List<String>
    abstract val testPuzzle2: List<String>?

    abstract val part1: Int
    abstract val part2: Int?

    @Test
    fun testPart1() {
        assertEquals(part1, day.part1(testPuzzle1))
    }

    @Test
    fun testPart2() {
        if (part2 != null)
            assertEquals(part2, day.part2(testPuzzle2 ?: testPuzzle1))
    }
}