//
//  DDA.m
//  Squares
//
//  Created by Robby Kraft on 10/23/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import "DDA.h"

@implementation DDA

-(NSInteger)indexFromScreen:(CGPoint)point
{
    int xIndex = point.x/_cellSize;
    int yIndex = point.y/_cellSize;
    return xIndex+yIndex*_segments;
}
-(CGPoint) indexPointFromScreen:(CGPoint)point
{
    int xIndex = point.x/_cellSize;
    int yIndex = point.y/_cellSize;
    return CGPointMake(xIndex, yIndex);
}
-(CGPoint) indexPointFromIndex:(NSInteger)index
{
    int xIndex = index%_segments;
    int yIndex = index/_segments;
    return CGPointMake(xIndex, yIndex);
}
-(NSInteger) indexForIndex:(CGPoint)indexPoint{
    return (int)indexPoint.x + (int)(indexPoint.y *_segments);
}
-(NSInteger) indexForTouch:(CGPoint)touchPoint{
    return (int)(touchPoint.x / _cellSize) + (int)(touchPoint.y / _cellSize) * _segments;
}
-(BOOL) CGPointIsEqual:(CGPoint)one To:(CGPoint)two{
    int x1 = one.x;
    int y1 = one.y;
    int x2 = two.x;
    int y2 = two.y;
    return (x1 == x2 && y1 == y2);
}
-(NSDictionary*)IndexesAndIntersectionsFromPoint:(CGPoint)start To:(CGPoint)end{
    NSMutableSet *intersections = [[NSMutableSet alloc] init];
    NSMutableSet *result = [[NSMutableSet alloc] init];
    CGFloat dx = end.x - start.x;
    CGFloat dy = end.y - start.y;
    CGFloat slope = (end.y - start.y) / (end.x - start.x);
    CGFloat angle = atan2f((end.y - start.y), (end.x - start.x));
    CGPoint here = [self indexPointFromScreen:start];
    CGPoint there = [self indexPointFromScreen:end];
    NSLog(@"DX:%.0f DY:%.0f SLOPE: %f  ANGLE:%f",dx,dy,slope,angle);  //    NSLog(@"### TAN(a):%f",tanf(angle));  // same as slope
    
    //add starting and ending cells
    [result addObject:[NSNumber numberWithInteger:[self indexForIndex:here]] ];
    [result addObject:[NSNumber numberWithInteger:[self indexForIndex:there]] ];
    // if only one cell is selected, return
    if([self CGPointIsEqual:here To:there])
        return @{@"indexes":result};
    // vertical line
    if((int)there.x == (int)here.x){
        int inc = (there.y > here.y)*2-1;
        int i = here.y;
        while(i != (int)there.y){
            [result addObject:[NSNumber numberWithInteger:[self indexForIndex:CGPointMake(here.x, i)]] ];
            i+=inc;
        }
        return @{@"indexes":result};
    }
    // horizontal line
    else if((int)there.y == (int)here.y){
        int i = here.x;
        int inc = (there.x > here.x)*2-1;
        while(i != (int)there.x){
            [result addObject:[NSNumber numberWithInteger:[self indexForIndex:CGPointMake(i, here.y)]] ];
            i+=inc;
        }
        return @{@"indexes":result};
    }
    //diagonal line
    else {
        CGFloat firstX = start.x-here.x*_cellSize;
        CGFloat firstY = start.y-here.y*_cellSize;
        //[intersections addObject:[NSValue valueWithCGPoint:CGPointMake(start.x,start.y) ]];
        
        //[intersections addObject:[NSValue valueWithCGPoint:CGPointMake(start.x+(_cellSize-firstX),start.y+(_cellSize-firstY)) ]];

//        [intersections addObject:[NSValue valueWithCGPoint:CGPointMake(start.x+(_cellSize-firstX),start.y+(_cellSize-firstX)*slope) ]];
        CGPoint firstXIntersect, firstYIntersect;
        if(dy > 0)
            firstXIntersect = CGPointMake(start.x+(_cellSize-firstY)/slope,start.y+(_cellSize-firstY));
        else
            firstXIntersect = CGPointMake(start.x-firstY/slope,start.y-firstY);
        [intersections addObject:[NSValue valueWithCGPoint:firstXIntersect ]];
        if(dx > 0)
            firstYIntersect = CGPointMake(start.x+(_cellSize-firstX),start.y+(_cellSize-firstX)*slope);
        else
            firstYIntersect = CGPointMake(start.x-firstX,start.y-firstX*slope);
        [intersections addObject:[NSValue valueWithCGPoint:firstYIntersect ]];
        
        
//        if((there.x - here.x) > 0){
//            NSInteger totalX = abs(there.x - here.x);
//            for(int i = 0; i < totalX; i++){
//                NSPoint *pointLeft = [NSPoint pX:here.x+i*dx  Y:here.y + ((.5+i) * tanf(angle) + .5) ];
////            NSPoint *pointRight = [NSPoint pX:here.x+i*dx+dx Y:here.y+ ((.5+i) * tanf(angle) + .5) ];
//                [result addObject:pointLeft];
////            if(pointRight.x <  BOARD_LENGTH)
////                [result addObject:pointRight];
//            }
//
//            NSInteger totalY = abs(there.y - here.y);
//            for(int i = 0; i < totalY; i++){
//                NSPoint *point = [NSPoint pX:here.x+ ((.5+i) / tanf(angle) + .5) Y:here.y+i*dy];
////            NSPoint *pointAbove = [NSPoint pX:here.x+ ((.5+i) / tanf(angle) + .5) Y:here.y+i*dy+dy];
//                [result addObject:point];
////            if(pointAbove.y < BOARD_WIDTH);
////            [result addObject:pointAbove];
//            }
//        }
        return @{@"indexes":result,@"intersections":intersections};
    }
}

@end
