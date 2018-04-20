package org.masapp.minegame

import org.masapp.minegame.Constant.MapSettings
import java.util.*

/**
 * Created by masapp on 2018/04/18.
 */
class MapGenerator {
  fun towDimensionalArrayForMap(): MutableList<MutableList<Int>> {
    val bombMap = fieldElement()
    val shuffleArray = shuffled(bombMap)
    val map = twoDimensionalArray(shuffleArray)
    return bombCount(map)
  }

  private fun fieldElement(): MutableList<Int> {
    var bombMap = mutableListOf<Int>()
    var bombIndex = 0
    for (i in 0 .. MapSettings.WIDTH_SQUARES * MapSettings.HEIGHT_SQUARES - 3) {
      if (bombIndex + 1 < MapSettings.BOMB_COUNT) {
        bombIndex += 1
        bombMap.add(MapSettings.BOMB)
      } else {
        bombMap.add(MapSettings.NORMAL)
      }
    }
    return bombMap
  }

  private fun shuffled(bombMap: MutableList<Int>): MutableList<Int> {
    var shuffleArray = MutableList(bombMap.size, {0})
    for (item in bombMap) {
      val count = shuffleArray.size - 1
      val randomNum = Random().nextInt(count)
      shuffleArray.add(randomNum, item)
    }

    shuffleArray.add(6, 0)
    shuffleArray.add(253, 0)

    return shuffleArray
  }

  private fun twoDimensionalArray(array: MutableList<Int>): MutableList<MutableList<Int>> {
    var twoDimensionalArray = mutableListOf<MutableList<Int>>()
    for (i in 0 .. MapSettings.HEIGHT_SQUARES - 1) {
      var tmpArray = mutableListOf<Int>()
      for (j in 0 .. MapSettings.WIDTH_SQUARES - 1) {
        tmpArray.add(array[i * MapSettings.WIDTH_SQUARES + j])
      }
      twoDimensionalArray.add(tmpArray)
    }
    return twoDimensionalArray
  }

  private fun bombCount(map: MutableList<MutableList<Int>>): MutableList<MutableList<Int>> {
    var countMap = map
    for (i in 0 .. countMap.size - 1) {
      for (j in 0 .. countMap[i].size - 1) {
        if (countMap[i][j] != -1) {
          continue
        }

        for (x in -1 .. 1) {
          for (y in -1 .. 1) {
            if (x == 0 && y == 0) {
              continue
            }
            if (i + x < 0 || countMap.size <= i + x || j + y < 0 || countMap[i].size <= j + y) {
              continue
            }
            if (countMap[i + x][j + y] != -1) {
              countMap[i + x][j + y] = countMap[i + x][j + y] + 1
            }
          }
        }
      }
    }
    return countMap
  }
}