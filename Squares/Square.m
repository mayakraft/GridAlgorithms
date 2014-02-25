//
//  Square.m
//  Squares
//
//  Created by Robby Kraft on 10/22/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import "Square.h"

@interface Square (){
    UIColor *normalColor;
}

@end

@implementation Square

-(id) initWithTexture:(SKTexture *)texture color:(UIColor *)color size:(CGSize)size{
    self = [super initWithTexture:texture color:color size:size];
    if(self){
        if(arc4random()%3 == 0)
            _disabled = true;
        else
            _disabled = false;
        if(_disabled)
            self.color = [UIColor blackColor];
        normalColor = self.color;
    }
    return self;
}

-(void) setHighlighted:(BOOL)highlighted{
    _highlighted = highlighted;
    if (_highlighted){
        [self setScale:0.95];
        [self setColor:_highlightedColor];
    }
    else{
        [self setScale:1.0];
        [self setColor:normalColor];
    }
}

@end
