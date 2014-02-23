//
//  ViewController.m
//  Squares
//
//  Created by Robby Kraft on 10/22/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import "ViewController.h"
#import "CellScene.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SKView * skView = [[SKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setView:skView];
    
    CellScene * scene = [[CellScene alloc] initWithSize:skView.bounds.size Columns:15];  //24
//    [CellScene sceneWithSize:skView.bounds.size];
//    [scene setSegments:15]; // 24
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:scene];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
