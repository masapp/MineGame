//
//  MapGenerator.swift
//  mineGame
//
//  Created by masapp on 2018/04/16.
//  Copyright © 2018 masapp. All rights reserved.
//

import UIKit

class MapGenerator {
    
    // MARK: - internal
    // create two dimensional array for map
    func towDimensionalArrayForMap() -> [[Int]] {
        // array of field element
        let bombMap = self.fieldElement()
        
        // shuffle
        let shuffleArray = self.shuffled(bombMap: bombMap)
        
        // two dimensional array
        let map = self.twoDimensionalArray(array: shuffleArray)
        
        // count of around bomb
        return self.bombCount(map: map)
    }
    
    // MARK: - private
    // add field element to array
    private func fieldElement() -> [Int] {
        var bombMap: [Int] = []
        var bombIndex = 0
        
        // except start and finish squares
        for _ in 0 ..< MapSettings.WIDTH_SQUARES * MapSettings.HEIGHT_SQUARES - 2 {
            if bombIndex + 1 < MapSettings.BOMB_COUNT {
                bombIndex += 1
                bombMap.append(MapSettings.BOMB)
            } else {
                bombMap.append(MapSettings.NORMAL)
            }
        }
        
        return bombMap
    }
    
    // array shuffle
    private func shuffled(bombMap: [Int]) -> [Int] {
        var shuffleArray = [Int](repeating: 0, count: bombMap.count)
        for object in bombMap {
            let count = shuffleArray.count - 1
            let randomNum = arc4random() % UInt32(count)
            shuffleArray[Int(randomNum)] = object
        }
        
        // add field element of start and finish squares
        shuffleArray.insert(0, at: 6)
        shuffleArray.insert(0, at: 253)
        
        return shuffleArray
    }
    
    // create two dimensional array
    private func twoDimensionalArray(array: [Int]) -> [[Int]] {
        var twoDimensionalArray: [[Int]] = []
        for i in 0 ..< MapSettings.HEIGHT_SQUARES {
            var tmpArray: [Int] = []
            for j in 0 ..< MapSettings.WIDTH_SQUARES {
                tmpArray.append(array[i * MapSettings.WIDTH_SQUARES + j])
            }
            twoDimensionalArray.append(tmpArray)
        }
        return twoDimensionalArray
    }
    
    // count of around bomb
    private func bombCount(map: [[Int]]) -> [[Int]] {
        var countMap = map
        for i in 0 ..< countMap.count {
            for j in 0 ..< countMap[i].count {
                // not bomb
                if countMap[i][j] != -1 {
                    continue
                }
                
                // examine around squares
                for x in -1 ... 1 {
                    for y in -1 ... 1 {
                        // own squares is not target
                        if x == 0 && y == 0 {
                            continue
                        }
                        // array outside is also not target
                        if i + x < 0 || countMap.count <= i + x || j + y < 0 || countMap[i].count <= j + y {
                            continue
                        }
                        // if not bomb, increase value
                        if countMap[i + x][j + y] != -1 {
                            countMap[i + x][j + y] = countMap[i + x][j + y] + 1
                        }
                    }
                }
            }
        }
        return countMap
    }
}
