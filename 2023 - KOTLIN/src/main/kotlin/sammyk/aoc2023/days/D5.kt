package sammyk.aoc2023.days

fun main() {
    D5().solve()
}

class D5 : Day(5) {
   override fun part1(puzzle: List<String>): Int {
       var wantedLocation = Long.MAX_VALUE

       val numbers = puzzle[0].split(':', ' ').drop(2).toList().map { it.toLong() }

       val converters = puzzle
           .drop(2)
           .joinToString("\n")
           .split("\n\n")
           .map { compact -> compact.split("\n").drop(1).map { line -> line.split(' ').map { it.toLong() } } }

       for (converter in converters) {
           numbers.forEach {
                TODO("Not yet implemented")
           }
       }

       return wantedLocation.toInt()
    }

    override fun part2(puzzle: List<String>): Int? {
        return null
    }
}