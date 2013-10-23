//
//  Square.m
//  Squares
//
//  Created by Robby Kraft on 10/22/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import "Square.h"

@implementation Square

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.layer setBorderColor:[UIColor blackColor].CGColor];
        [self.layer setBorderWidth:0.0];
    }
    return self;
}


-(void) setHighlight:(BOOL)highlight{
    _highlight = highlight;
    if (_highlight){
        [self.layer setBorderWidth:1.0];
//        [self setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        [self.layer setBorderWidth:0.0];
//        [self setBackgroundColor:[UIColor blackColor]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
