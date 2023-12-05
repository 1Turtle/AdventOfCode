package days

import TestDay

class D1Test : TestDay() {

    override val day = D1()

    override val part1 = 142
    override val part2 = 281

    override val testPuzzle1 = listOf(
        "1abc2",
        "pqr3stu8vwx",
        "a1b2c3d4e5f",
        "treb7uchet"
    )
    override val testPuzzle2 = listOf(
        "two1nine",
        "eightwothree",
        "abcone2threexyz",
        "xtwone3four",
        "4nineeightseven2",
        "zoneight234",
        "7pqrstsixteen"
    )
}