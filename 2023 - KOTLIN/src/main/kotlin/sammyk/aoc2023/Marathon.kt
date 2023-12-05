package sammyk.aoc2023

import sammyk.aoc2023.days.Day
import kotlin.reflect.full.createInstance

fun main()  {
    Day::class.sealedSubclasses.forEach {
        it.createInstance().solve()
        println()
    }
}