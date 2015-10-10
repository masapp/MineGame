//
//  GameViewController.m
//  mineGame
//
//  Created by masapp on 2015/05/03.
//  Copyright (c) 2015年 masapp. All rights reserved.
//

#import "GameViewController.h"
#import "MapGenerator.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect windowSize = [[UIScreen mainScreen] bounds];
    
    wscale = windowSize.size.width / 320;
    hscale = windowSize.size.height / 568;
    squareWidth = 21.5 * wscale;
    squareHeight = 21.5 * hscale;
    groundWidth = squareWidth * 0.975;
    groundHeight = squareHeight * 0.975;
    
    // background
    UIImageView *background = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    background.image = [UIImage imageNamed:@"grass.png"];
    [self.view addSubview:background];
    
    // character controle button
    UIImageView *control = [[UIImageView alloc] initWithFrame:CGRectMake(9.6 * wscale, 471 * hscale, 96 * wscale, 96 * hscale)];
    control.image = [UIImage imageNamed:@"button_control.png"];
    [self.view addSubview:control];
    
    // chara at say numbers
    UIImageView *sayCharacter = [[UIImageView alloc] initWithFrame:CGRectMake(166.4 * wscale, 471 * hscale, 150.4 * wscale, 96 * hscale)];
    sayCharacter.image = [UIImage imageNamed:@"usayuki.png"];
    [self.view addSubview:sayCharacter];
    
    // current number
    currentNumber = [[UILabel alloc] initWithFrame:CGRectMake(189 * wscale, 465 * hscale, 96 * wscale, 96 * hscale)];
    currentNumber.font = [UIFont systemFontOfSize:70 * wscale];
    [self.view addSubview:currentNumber];
    
    // stage info
    stageInfo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 199 * hscale, windowSize.size.width, 51 * hscale)];
    stageInfo.image = [UIImage imageNamed:@"info.png"];
    stageInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(80 * wscale, 0, 499 * wscale, 51 * hscale)];
    stageInfoLabel.font = [UIFont systemFontOfSize:30 * wscale];
    stageInfoLabel.textColor = [UIColor whiteColor];
    [stageInfo addSubview:stageInfoLabel];
    
    retryLabel = [[UILabel alloc] initWithFrame:CGRectMake(80 * wscale, 295 * hscale, 99 * wscale, 51 * hscale)];
    retryLabel.font = [UIFont systemFontOfSize:30 * wscale];
    retryLabel.textColor = [UIColor whiteColor];
    retryLabel.text = @"retry";

    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(202 * wscale, 295 * hscale, 99 * wscale, 51 * hscale)];
    titleLabel.font = [UIFont systemFontOfSize:30 * wscale];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"title";
    
    stageCount = 1;
    
    [self stageStart];
}

- (void)drawMap:(NSMutableArray *)mapArray
{
    [self drawGround:mapArray];
    [self drawFence];
}

- (void)drawGround:(NSMutableArray *)mapArray
{
    // draw ground
    for (int i = 0; i < [mapArray count]; i++) {
        for (int j = 0; j < [mapArray[i] count]; j++) {
            
            // ground
            UIImageView *ground = [[UIImageView alloc] initWithFrame:CGRectMake(squareWidth * (j + 1), squareHeight * (i + 1), groundWidth, groundHeight)];
            ground.image = [UIImage imageNamed:@"soil.png"];
            [self.view addSubview:ground];
        }
    }
}

- (void)drawFence
{
    // left top corner
    UIImageView *leftTopCorner = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, groundWidth, groundHeight)];
    leftTopCorner.image = [UIImage imageNamed:@"left_top_corner.png"];
    [self.view addSubview:leftTopCorner];
    
    // right top corner
    UIImageView *rightTopCorner = [[UIImageView alloc] initWithFrame:CGRectMake(squareWidth * 14, 0, groundWidth, groundHeight)];
    rightTopCorner.image = [UIImage imageNamed:@"right_top_corner.png"];
    [self.view addSubview:rightTopCorner];
    
    // left under corner
    UIImageView *leftUnderCorner = [[UIImageView alloc] initWithFrame:CGRectMake(0, squareHeight * 21, groundWidth, groundHeight)];
    leftUnderCorner.image = [UIImage imageNamed:@"left_under_corner.png"];
    [self.view addSubview:leftUnderCorner];
    
    // right under corner
    UIImageView *rightUnderCorner = [[UIImageView alloc] initWithFrame:CGRectMake(squareWidth * 14, squareHeight * 21, groundWidth, groundHeight)];
    rightUnderCorner.image = [UIImage imageNamed:@"right_under_corner.png"];
    [self.view addSubview:rightUnderCorner];
    
    // height
    for (int i = 0; i < 20; i++) {
        UIImageView *leftHeight = [[UIImageView alloc] initWithFrame:CGRectMake(0, squareHeight * (i + 1), groundWidth, groundHeight)];
        leftHeight.image = [UIImage imageNamed:@"height.png"];
        [self.view addSubview:leftHeight];
    }
    for (int i = 0; i < 20; i++) {
        UIImageView *rightHeight = [[UIImageView alloc] initWithFrame:CGRectMake(squareWidth * 14, squareHeight * (i + 1), groundWidth, groundHeight)];
        rightHeight.image = [UIImage imageNamed:@"height.png"];
        [self.view addSubview:rightHeight];
    }
    
    // width
    for (int i = 0; i < 5; i++) {
        UIImageView *leftTopWidth = [[UIImageView alloc] initWithFrame:CGRectMake(squareWidth * (i + 1), 0, groundWidth, groundHeight)];
        leftTopWidth.image = [UIImage imageNamed:@"width.png"];
        [self.view addSubview:leftTopWidth];
    }
    for (int i = 0; i < 5; i++) {
        UIImageView *rightTopWidth = [[UIImageView alloc] initWithFrame:CGRectMake(squareWidth * (i + 9), 0, groundWidth, groundHeight)];
        rightTopWidth.image = [UIImage imageNamed:@"width.png"];
        [self.view addSubview:rightTopWidth];
    }
    for (int i = 0; i < 5; i++) {
        UIImageView *leftUnderWidth = [[UIImageView alloc] initWithFrame:CGRectMake(squareWidth * (i + 1), squareHeight * 21, groundWidth, groundHeight)];
        leftUnderWidth.image = [UIImage imageNamed:@"width.png"];
        [self.view addSubview:leftUnderWidth];
    }
    for (int i = 0; i < 5; i++) {
        UIImageView *rightUnderWidth = [[UIImageView alloc] initWithFrame:CGRectMake(squareWidth * (i + 9), squareHeight * 21, groundWidth, groundHeight)];
        rightUnderWidth.image = [UIImage imageNamed:@"width.png"];
        [self.view addSubview:rightUnderWidth];
    }
    
    // left end
    for (int i = 0; i < 2; i++) {
        UIImageView *leftEnd = [[UIImageView alloc] initWithFrame:CGRectMake(squareWidth * 8, squareHeight * 21 * i, groundWidth, groundHeight)];
        leftEnd.image = [UIImage imageNamed:@"left_end.png"];
        [self.view addSubview:leftEnd];
    }
    
    // right end
    for (int i = 0; i < 2; i++) {
        UIImageView *rightEnd = [[UIImageView alloc] initWithFrame:CGRectMake(squareWidth * 6, squareHeight * 21 * i, groundWidth, groundHeight)];

        rightEnd.image = [UIImage imageNamed:@"right_end.png"];
        [self.view addSubview:rightEnd];
    }
    
    // start and end
    for (int i = 0; i < 2; i++) {
        UIImageView *flat = [[UIImageView alloc] initWithFrame:CGRectMake(squareWidth * 7, squareHeight * 21 * i, groundWidth, groundHeight)];
        flat.image = [UIImage imageNamed:@"grass.png"];
        [self.view addSubview:flat];
    }
}

// put the character to the start position
- (void)setCharacter
{
    character = [[UIImageView alloc] initWithFrame:CGRectMake(squareWidth * 7, squareHeight * 21, groundWidth, groundHeight)];
    character.image = [UIImage imageNamed:@"back.png"];
    [self.view addSubview:character];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    
    if ([status  isEqual:@"play"]) {
        // up or down
        if (41.5 * wscale <= location.x && location.x <= 75 * wscale) {
            if (475 * hscale <= location.y && location.y <= 505.5 * hscale) {
                character.image = [UIImage imageNamed:@"back.png"];
                [self moveCharactor:CGPointMake(0, -squareHeight)];
            } else if (535 * hscale <= location.y && location.y <= 565 * hscale) {
                character.image = [UIImage imageNamed:@"front.png"];
                [self moveCharactor:CGPointMake(0, squareHeight)];
            }
        }
    
        // left or right
        if (505.5 * hscale < location.y && location.y <= 535 * hscale) {
            if (10 * wscale <= location.x && location.x <= 42 * wscale) {
                character.image = [UIImage imageNamed:@"left.png"];
                [self moveCharactor:CGPointMake(-squareWidth, 0)];
            } else if (77 * wscale <= location.x && location.x <= 105 * wscale) {
                character.image = [UIImage imageNamed:@"right.png"];
                [self moveCharactor:CGPointMake(squareWidth, 0)];
            }
        }
    } else if ([status  isEqual:@"gameOver"]) {
        if (312 * hscale <= location.y && location.y <= 340 * hscale) {
            if (80 * wscale <= location.x && location.x <= 145 * wscale) {
                stageCount = 1;
                [self stageStart];
                [retryLabel removeFromSuperview];
                [titleLabel removeFromSuperview];
            } else if (195 * wscale <= location.x && location.x <= 255 * wscale) {
                [self dismissViewControllerAnimated:NO completion:nil];
            }
        }
    }
}

- (void)moveCharactor:(CGPoint)point
{
    CGPoint nowPoint = character.frame.origin;
    
    if ([self moveValidate:point]) {
        return;
    }
    
    // charecter move
    character.frame = (CGRect){.origin.x = nowPoint.x + point.x, .origin.y = nowPoint.y + point.y, .size = character.frame.size};
    
    if (character.frame.origin.x == (squareWidth * 7) && round(character.frame.origin.y) == 0) {
        [self stageComplete];
        return;
    }
    
    // check bomb
    [self checkBomb:character.frame.origin];
}

- (BOOL)moveValidate:(CGPoint)point
{
    CGPoint nowPoint = character.frame.origin;
    
    // start position
    if (nowPoint.x== (squareWidth * 7) && nowPoint.y == (squareHeight * 21)) {
        if (point.x != 0) {
            return true;
        }
    }
    
    // left validate
    if (nowPoint.x <= squareWidth && point.x == -squareWidth) {
        return true;
    }
    
    // right validate
    if (round(nowPoint.x) >= round((squareWidth * 13)) && point.x == squareWidth) {
        return true;
    }
    
    // down validate
    if (nowPoint.y >= (squareHeight * 20) && point.y == squareHeight) {
        return true;
    }
    
    // up validate
    if (round(nowPoint.y) <= round(squareHeight) && point.y == -squareHeight) {
        if (nowPoint.x != (squareWidth * 7) || round(nowPoint.y) != round(squareHeight)) {
            return true;
        }
    }
    
    return false;
}

- (void)stageStart
{
    // disable touch events
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    MapGenerator *mapGenerator = [[MapGenerator alloc] init];
    map = [mapGenerator twoDimensionalArrayForMap];
    
    [self drawMap:map];
    
    // put the character to the start position
    [self setCharacter];
    
    // current square number init
    currentNumber.text = @"";
    
    // show next stage count
    [self.view addSubview:stageInfo];
    stageInfoLabel.text = [NSString stringWithFormat:@"stage %d start", stageCount];
    
    // timer to hide stage info
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(hideStartInfo:) userInfo:nil repeats:NO];
}

- (void)stageComplete
{
    // disable touch events
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    // show stage clear info
    [self.view addSubview:stageInfo];
    stageInfoLabel.text = [NSString stringWithFormat:@"stage %d clear", stageCount];
    
    stageCount++;
    
    // timer to hide stage info
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(hideClearInfo:) userInfo:nil repeats:NO];
}

- (id)getSquareNumber:(CGPoint)point
{
    int i = point.y / squareHeight - 1;
    int j = point.x / squareWidth - 1;
    
    return map[i][j];
}

- (void)hideStartInfo:(NSTimer *)timer
{
    // enable touch events
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    [stageInfo removeFromSuperview];
    
    status = @"play";
}

- (void)hideClearInfo:(NSTimer *)timer
{
    // enable touch events
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];

    [stageInfo removeFromSuperview];
    
    // start next stage
    [self stageStart];
}

- (void)checkBomb:(CGPoint)point
{
    id squareNumber = [self getSquareNumber:point];
    
    if ([squareNumber intValue] == -1) {
        [self.view addSubview:stageInfo];
        stageInfoLabel.text = [NSString stringWithFormat:@"game over"];
        status = @"gameOver";
        
        [self.view addSubview:retryLabel];
        [self.view addSubview:titleLabel];
    } else {
        // current square number
        currentNumber.text = [NSString stringWithFormat:@"%@", squareNumber];
        
        // bomb count
        UIImageView *bombCount =[[UIImageView alloc] initWithFrame:CGRectMake(point.x, point.y, groundWidth, groundHeight)];
        bombCount.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", squareNumber]];
        [self.view addSubview:bombCount];
        [self.view bringSubviewToFront:character];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
