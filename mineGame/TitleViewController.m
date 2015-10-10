//
//  TitleViewController.m
//  mineGame
//
//  Created by masapp on 2015/05/03.
//  Copyright (c) 2015年 masapp. All rights reserved.
//

#import "TitleViewController.h"
#import "GameViewController.h"

@interface TitleViewController ()

@end

@implementation TitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UIImageView *title = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    title.image = [UIImage imageNamed:@"title.png"];
    [self.view addSubview:title];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    GameViewController *gameViewController = [[GameViewController alloc] init];
    [self presentViewController:gameViewController animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
