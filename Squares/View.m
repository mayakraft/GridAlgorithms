//
//  View.m
//  Squares
//
//  Created by Robby Kraft on 10/22/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import "View.h"
#import "Square.h"
#import "DDA.h"

@interface View (){
    NSMutableArray *cells;
    CGPoint touch;
    CGPoint touchStart;
//    UIView *surface;
    NSSet *crossedCells;  //set of cells the line crosses
    DDA *dda;
    NSMutableArray *points;
}

@end

@implementation View

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setSegments:(NSInteger)segments{
    cells = [NSMutableArray array];
    points = [NSMutableArray array];
//    surface = [[UIView alloc] initWithFrame:self.bounds];
//    [surface setBackgroundColor:[UIColor clearColor]];
//    [self addSubview:surface];
    _segments = segments;
    _cellSize = self.bounds.size.width/_segments;
    dda = [[DDA alloc] init];
    [dda setSegments:_segments];
    [dda setCellSize:_cellSize];
    for(int i = 0; i < (int)(self.bounds.size.height/_segments) * (int)(self.bounds.size.width/_segments); i++){
        Square *square = [[Square alloc] initWithFrame:CGRectMake(0, 0, _cellSize, _cellSize)];
        [square setCenter:CGPointMake(_cellSize/2.0+_cellSize*(i%_segments), _cellSize/2.0+_cellSize*(int)(i/_segments))];
        [square setBackgroundColor:[UIColor colorWithWhite:arc4random()%20/100.+.8 alpha:1.0]];
        [self addSubview:square];
        [cells addObject:square];
    }
    for(int i = 0; i < _segments*4; i++){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-20, -20, 5, 5)];
        [view setBackgroundColor:[UIColor colorWithRed:0.15 green:0.2 blue:0.7 alpha:1.0]];
        [self addSubview:view];
        [points addObject:view];
    }
//    [self bringSubviewToFront:surface];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    touchStart = [[touches anyObject] locationInView:self];
    [self touchesMoved:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    touch = [(UITouch*)[touches anyObject] locationInView:self];
    NSDictionary *DDADictionary = [dda IndexesAndIntersectionsFromPoint:touchStart To:touch];
    NSSet *DDAIndexes = [DDADictionary objectForKey:@"indexes"];
    NSSet *intersects = [DDADictionary objectForKey:@"intersections"];
    if(![DDAIndexes isEqualToSet:crossedCells]){
        for(NSNumber *n in crossedCells)
            [cells[[n integerValue]] setHighlight:NO];
        crossedCells = DDAIndexes;
        for(NSNumber *n in crossedCells)
            [cells[[n integerValue]] setHighlight:YES];
    }
    NSArray *pointLocations = intersects.allObjects;
    for(int i = 0; i < pointLocations.count; i++){
        CGPoint pointLocation = [[pointLocations objectAtIndex:i] CGPointValue];
        [[points objectAtIndex:i] setCenter:pointLocation];
    }
    
//    [self drawlineFromPoint:touchStart toPoint:touch];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
}

//- (void)drawlineFromPoint:(CGPoint)firstPoint toPoint:(CGPoint)secondPoint{
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:firstPoint];
//    [path addLineToPoint:secondPoint];
//    
//    CAShapeLayer *myLayer = [[CAShapeLayer alloc] init];
//    myLayer.strokeColor = [[UIColor blackColor] CGColor];
//    myLayer.lineWidth = 1.0;
//    myLayer.lineJoin = kCALineCapRound;
//    myLayer.path = path.CGPath;
//    surface.layer.sublayers = nil;
//    [surface.layer addSublayer:myLayer];
//}

@end
