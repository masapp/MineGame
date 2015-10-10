//
//  MapGenerator.m
//  mineGame
//
//  Created by masapp on 2015/05/03.
//  Copyright (c) 2015年 masapp. All rights reserved.
//

#import "MapGenerator.h"

// squares count width * height
#define WIDTH_SQUARES 13
#define HEIGHT_SQUARES 20

// bomb count
#define BOMB_COUNT 30

// field state
#define BOMB -1
#define NORMAL 0

@interface MapGenerator ()

@end

@implementation MapGenerator

// create two dimensional array for map
- (NSMutableArray *)twoDimensionalArrayForMap
{
    NSMutableArray *map = [NSMutableArray array];
    
    // array of field element
    NSMutableArray *bombMap = [self fieldElement];
    
    // shuffle
    NSMutableArray *shuffleArray = [self shuffled:bombMap];
    
    // two dimensional array
    map = [self twoDimensionalArray:shuffleArray];
    
    // count of around bomb
    [self bombsCount:map];
    
    return map;
}

// add field element to array
- (NSMutableArray *)fieldElement
{
    NSMutableArray *bombMap = [NSMutableArray array];
    int bombIndex = 0;
    
    // except start and finish squares
    for (int i = 0; i < WIDTH_SQUARES * HEIGHT_SQUARES - 2; i++) {
        if (bombIndex++ < BOMB_COUNT) {
            [bombMap addObject:[NSNumber numberWithInt:BOMB]];
        } else {
            [bombMap addObject:[NSNumber numberWithInt:NORMAL]];
        }
    }
    
    return bombMap;
}

// array shuffle
- (NSMutableArray *)shuffled:(NSMutableArray *)bombMap
{
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[bombMap count]];

    for (id object in bombMap) {
        NSUInteger randomNum = arc4random() % ([tmpArray count] + 1);
        [tmpArray insertObject:object atIndex:randomNum];
    }
    
    // add field element of start and finish squares
    [tmpArray insertObject:[NSNumber numberWithInt:0] atIndex:6];
    [tmpArray insertObject:[NSNumber numberWithInt:0] atIndex:253];
    
    return tmpArray;
}

// create two dimensional array
- (NSMutableArray *)twoDimensionalArray:(NSMutableArray *)array
{
    NSMutableArray *twoDimensionalArray = [NSMutableArray array];
    
    for (int i = 0; i < HEIGHT_SQUARES; i++) {
        NSMutableArray *tmpArray = [NSMutableArray array];
        for (int j = 0; j < WIDTH_SQUARES; j++) {
            [tmpArray addObject:array[i * WIDTH_SQUARES + j]];
        }
        [twoDimensionalArray addObject:tmpArray];
    }
    
    return twoDimensionalArray;
}

// count of around bomb
- (void)bombsCount:(NSMutableArray *)map
{
    for (int i = 0; i < [map count]; i++) {
        for (int j = 0; j < [map[i] count]; j++) {
            // not bomb
            if ([map[i][j] intValue] != -1) {
                continue;
            }
            
            // examine around the squares
            for (int x = -1; x <= 1; x++) {
                for (int y = -1; y <= 1; y++) {
                    // own squares is not target
                    if (x == 0 && y == 0) {
                        continue;
                    }
                    // array outside is also not target
                    if (i + x < 0 || [map count] <= i + x || j + y < 0 || [map[i] count] <= j + y) {
                        continue;
                    }
                    // if not bomb, increase value
                    if ([map[i + x][j + y] intValue] != -1) {
                        [map[i + x] replaceObjectAtIndex:j + y withObject:[NSNumber numberWithInt:[map[i + x][j + y] intValue] + 1]];
                    }
                }
            }
        }
    }
}

@end
