package sammyk.aoc2023.days

import kotlin.math.abs

fun main() {
    D5().solve()
}

class D5 : Day(5) {
   override fun part1(puzzle: List<String>): Long {
       val numbers = puzzle[0].split(':', ' ').drop(2).toList().map { it.toLong() }.toMutableList()

       val converters = puzzle
           .drop(2)
           .joinToString("\n")
           .split("\n\n")
           .map { compact -> compact.split("\n").drop(1).map { line -> line.split(' ').map { it.toLong() } } }

       for (converter in converters) {
           val applied = mutableListOf<Boolean>()
           applied.addAll(numbers.map { false })

           numbers.withIndex().forEach { number ->
               for (rule in converter) {
                   if (rule[1] <= number.value && number.value <= rule[1]+rule[2]-1) {
                       numbers[number.index] = rule[0] + abs(number.value-rule[1])
                       applied[number.index] = true
                   }

                   if (applied[number.index])
                       break
               }
           }
       }

       numbers.sort()

       return numbers[0]
    }

    override fun part2(puzzle: List<String>): Long? {
        return null
    }
}