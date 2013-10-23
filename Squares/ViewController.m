//
//  ViewController.m
//  Squares
//
//  Created by Robby Kraft on 10/22/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import "ViewController.h"
#import "View.h"

@interface ViewController (){
    View *view;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	view = [[View alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [view setSegments:10];
    [self setView:view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
