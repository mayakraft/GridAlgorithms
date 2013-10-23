//
//  Square.m
//  Squares
//
//  Created by Robby Kraft on 10/22/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import "Square.h"

@implementation Square

-(void) setHighlighted:(BOOL)highlighted{
    _highlighted = highlighted;
    if (_highlighted){
        [self setScale:0.95];
    }
    else{
        [self setScale:1.0];
    }
}

@end
