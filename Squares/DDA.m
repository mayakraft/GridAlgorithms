//
//  DDA.m
//  Squares
//
//  Created by Robby Kraft on 10/23/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import "DDA.h"

@implementation DDA

// hardcoded for squares
-(void)setCellSize:(CGFloat)cellSize{
    _cellSize = cellSize;
    _cellSizeX = cellSize;
    _cellSizeY = cellSize;
}
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
    int xIndex = (int)index%_segments;
    int yIndex = (int)index/_segments;
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
//    CGFloat angle = atan2f((end.y - start.y), (end.x - start.x));
    CGPoint here = [self indexPointFromScreen:start];
    CGPoint there = [self indexPointFromScreen:end];
//    NSLog(@"DX:%.0f DY:%.0f SLOPE: %f  ANGLE:%f",dx,dy,slope,angle);  //    NSLog(@"### TAN(a):%f",tanf(angle));  // same as slope
    
    // if only one cell is selected, return
    if([self CGPointIsEqual:here To:there]){
        [result addObject:[NSNumber numberWithInteger:[self indexForIndex:here]] ];
        return @{@"indexes":result};
    }
    // vertical line
    if((int)there.x == (int)here.x){
        //add starting and ending cells
        [result addObject:[NSNumber numberWithInteger:[self indexForIndex:here]] ];
        [result addObject:[NSNumber numberWithInteger:[self indexForIndex:there]] ];
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
        //add starting and ending cells
        [result addObject:[NSNumber numberWithInteger:[self indexForIndex:here]] ];
        [result addObject:[NSNumber numberWithInteger:[self indexForIndex:there]] ];
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
        CGFloat halfCell = _cellSize/2.0;
        CGFloat firstX = start.x-here.x*_cellSize;
        CGFloat firstY = start.y-here.y*_cellSize;
        CGPoint firstXIntersect, firstYIntersect;
        if(dy > 0)
            firstXIntersect = CGPointMake(start.x+(_cellSize-firstY)/slope,start.y+(_cellSize-firstY));
        else
            firstXIntersect = CGPointMake(start.x-firstY/slope,start.y-firstY);
        if(dx > 0)
            firstYIntersect = CGPointMake(start.x+(_cellSize-firstX),start.y+(_cellSize-firstX)*slope);
        else
            firstYIntersect = CGPointMake(start.x-firstX,start.y-firstX*slope);

        // X intersects
        if(dy>0){
            int i = 0;
            while(firstXIntersect.y + _cellSizeY*i < end.y){
                CGPoint next = CGPointMake(firstXIntersect.x + _cellSizeY/slope*i, firstXIntersect.y + _cellSizeY*i);
                [intersections addObject:[NSValue valueWithCGPoint:next]];
                [result addObject:[NSNumber numberWithInteger:[self indexFromScreen:CGPointMake(next.x, next.y+halfCell)]] ];
                [result addObject:[NSNumber numberWithInteger:[self indexFromScreen:CGPointMake(next.x, next.y-halfCell)]] ];
                i++;
            }
        }
        else{
            int i = 0;
            while(firstXIntersect.y - _cellSizeY*i > end.y){
                CGPoint next = CGPointMake(firstXIntersect.x - _cellSizeY/slope*i, firstXIntersect.y - _cellSizeY*i);
                [intersections addObject:[NSValue valueWithCGPoint:next]];
                [result addObject:[NSNumber numberWithInteger:[self indexFromScreen:CGPointMake(next.x, next.y+halfCell)]] ];
                [result addObject:[NSNumber numberWithInteger:[self indexFromScreen:CGPointMake(next.x, next.y-halfCell)]] ];
                i++;
            }
        }
        // Y intersects
        if(dx > 0){
            int i = 0;
            while(firstYIntersect.x + _cellSizeX*i < end.x){
                CGPoint next = CGPointMake(firstYIntersect.x + _cellSizeX*i, firstYIntersect.y + _cellSizeX*slope*i);
                [intersections addObject:[NSValue valueWithCGPoint:next]];
                [result addObject:[NSNumber numberWithInteger:[self indexFromScreen:CGPointMake(next.x+halfCell, next.y)]] ];
                [result addObject:[NSNumber numberWithInteger:[self indexFromScreen:CGPointMake(next.x-halfCell, next.y)]] ];
                i++;
            }
        }
        else{
            int i = 0;
            while(firstYIntersect.x - _cellSizeX*i > end.x){
                CGPoint next = CGPointMake(firstYIntersect.x - _cellSizeX*i, firstYIntersect.y - _cellSizeX*slope*i);
                [intersections addObject:[NSValue valueWithCGPoint:next]];
                [result addObject:[NSNumber numberWithInteger:[self indexFromScreen:CGPointMake(next.x+halfCell, next.y)]] ];
                [result addObject:[NSNumber numberWithInteger:[self indexFromScreen:CGPointMake(next.x-halfCell, next.y)]] ];
                i++;
            }
        }
        return @{@"indexes":result,@"intersections":intersections};
    }
}

@end
