package sammyk.aoc2023.days

fun main() {
    D1().solve()
}

class D1 : Day(1) {

    override fun part1(puzzle: List<String>): Int {
        var calibration = 0

        for (line in puzzle) {
            val filtered = line.replace("[^0-9]".toRegex(), "")
            calibration += "${filtered.first()}${filtered.last()}".toInt()
        }

        return calibration
    }

    override fun part2(puzzle: List<String>): Int {
        var calibration = 0
        val lexicon = mutableMapOf(
            "one" to "1",
            "two" to "2",
            "three" to "3",
            "four" to "4",
            "five" to "5",
            "six" to "6",
            "seven" to "7",
            "eight" to "8",
            "nine" to "9"
        )
        val combinations = mutableMapOf<String, String>()

        // Find word pairs sharing the same first and last letter
        for ((leftW, leftN) in lexicon)
            for ((rightW, rightN) in lexicon)
                if (leftW[leftW.length-1] == rightW[0])
                    combinations[(leftW + rightW.subSequence(1..rightW.lastIndex))] = (leftN + rightN)

        for (line in puzzle) {
            var cleared = line

            for ((word, number) in (combinations + lexicon))
                cleared = cleared.replace(word, number)

            val filtered = cleared.replace("[^0-9]".toRegex(), "")

            calibration += "${filtered.first()}${filtered.last()}".toInt()
        }

        return calibration
    }
}