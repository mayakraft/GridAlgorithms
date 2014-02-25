//
//  View.m
//  Squares
//
//  Created by Robby Kraft on 10/22/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import "CellScene.h"
#import "Square.h"
#include "AStar.h"

@interface CellScene (){
    NSMutableArray *cells;
    CGPoint touchEnd;
    CGPoint touchStart;
    int cellStart;
    int cellEnd;
    AStar aStar;
    SKSpriteNode *startCellSprite;
    SKSpriteNode *endCellSprite;
    int *obstacleCellsForAStar;
    int *path;
    int pathSize;
}
@end

@implementation CellScene

// rows generate automatically based on aspect ratio
-(id) initWithSize:(CGSize)size Columns:(int)c{
    self = [super initWithSize:size];
    if(self){
        _columns = c;
        // todo: if portrait do the following. if landscape, invert it.
        _rows = [[UIScreen mainScreen] bounds].size.height / [[UIScreen mainScreen] bounds].size.width * _columns;
        // sprite kit graphics
        cells = [NSMutableArray array];
        _cellSize = self.size.width/_columns;
        startCellSprite = [[SKSpriteNode alloc] initWithTexture:Nil color:[UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.5] size:CGSizeMake(_cellSize, _cellSize)];
        endCellSprite = [[SKSpriteNode alloc] initWithTexture:Nil color:[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.5] size:CGSizeMake(_cellSize, _cellSize)];
        [startCellSprite setHidden:YES];
        [endCellSprite setHidden:YES];
        for(int i = 0; i < _columns*_rows; i++){
            Square *square = [[Square alloc] initWithTexture:Nil color:[UIColor colorWithWhite:arc4random()%20/100.+.8 alpha:1.0] size:CGSizeMake(_cellSize, _cellSize)];
            [square setPosition:CGPointMake(_cellSize/2.0+_cellSize*(i%_columns), _cellSize/2.0+_cellSize*(int)(i/_columns))];
            [self addChild:square];
            [cells addObject:square];
        }
        for(int i = 0; i < _columns*4; i++){
            SKSpriteNode *pointNode = [[SKSpriteNode alloc] initWithTexture:nil color:[UIColor blackColor] size:CGSizeMake(5, 5)];
            [self addChild:pointNode];
        }
    }
    [self addChild:startCellSprite];
    [self addChild:endCellSprite];
    cellStart = cellEnd = -1;
    
    obstacleCellsForAStar = (int*)malloc(sizeof(bool)*_columns*_rows);
    for(int i = 0; i < _columns*_rows; i++){
        if( [[cells objectAtIndex:i] disabled] )
            obstacleCellsForAStar[i] = true;
        else
            obstacleCellsForAStar[i] = false;
    }
    path = (int*)malloc(sizeof(int)*_columns*_rows);
    pathSize = 0;
    aStar.setup(_columns, _rows, obstacleCellsForAStar);
        
    return self;
}

-(void) updateStartCell{
    [startCellSprite setHidden:NO];
    [startCellSprite setPosition:CGPointMake(_cellSize/2.0+_cellSize*(cellStart%_columns), _cellSize/2.0+_cellSize*(int)(cellStart/_columns))];
}

-(void) updateEndCell{
    [endCellSprite setHidden:NO];
    [endCellSprite setPosition:CGPointMake(_cellSize/2.0+_cellSize*(cellEnd%_columns), _cellSize/2.0+_cellSize*(int)(cellEnd/_columns))];
}

-(int) indexForTouch:(CGPoint)touchPoint{
    return (int)(touchPoint.x / _cellSize) + (int)(touchPoint.y / _cellSize) * _columns;
}

-(CGPoint) indexPointForTouch:(CGPoint)touchPoint{
    return CGPointMake([self indexForTouch:touchPoint] % _columns, [self indexForTouch:touchPoint] / _columns);
}

-(CGPoint) indexPointForIndex:(int)selection{
    return CGPointMake(selection % _columns, selection / _columns);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    touchStart = [[touches anyObject] locationInNode:self];
    cellStart = [self indexForTouch:touchStart];
    [self updateStartCell];
    [self touchesMoved:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    touchEnd = [(UITouch*)[touches anyObject] locationInNode:self];
    int cellForTouch = [self indexForTouch:touchEnd];
    if(cellForTouch != cellEnd){  // finger has entered a new cell, update calculations
        cellEnd = cellForTouch;
        [self updateEndCell];
        CGPoint touchCellEnd = [self indexPointForIndex:cellEnd];
        NSLog(@"(%d, %d)",(int)touchCellEnd.x, (int)touchCellEnd.y);
        for(int i = 0; i < pathSize; i++)
            [[cells objectAtIndex:path[i]] setHighlighted:NO];
        aStar.pathFromAtoB(cellStart, cellEnd, path, &pathSize);
        for(int i = 0; i < pathSize; i++)
            [[cells objectAtIndex:path[i]] setHighlighted:YES];
    }
//    NSDictionary *DDADictionary = [dda IndexesAndIntersectionsFromPoint:touchStart To:touch];
//    DDAIndexes = [DDADictionary objectForKey:@"indexes"];
//    intersects = [DDADictionary objectForKey:@"intersections"];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    [startCellSprite setHidden:YES];
//    [endCellSprite setHidden:YES];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
