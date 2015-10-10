//
//  GameViewController.h
//  mineGame
//
//  Created by masapp on 2015/05/03.
//  Copyright (c) 2015年 masapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController {
    UIImageView *character;
    UIImageView *stageInfo;
    
    NSMutableArray *map;
    
    UILabel *currentNumber;
    UILabel *stageInfoLabel;
    UILabel *retryLabel;
    UILabel *titleLabel;
    
    NSString *status;
    
    int stageCount;
    
    float wscale;
    float hscale;
    float squareWidth;
    float squareHeight;
    float groundWidth;
    float groundHeight;
}


@end

