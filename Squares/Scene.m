//
//  View.m
//  Squares
//
//  Created by Robby Kraft on 10/22/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import "Scene.h"
#import "Square.h"
#import "DDA.h"

@interface Scene (){
    NSMutableArray *cells;
    CGPoint touch;
    CGPoint touchStart;
    NSSet *crossedCells;  //set of cells the line crosses
    DDA *dda;
    NSMutableArray *points;   //points of intersect, SKSpriteNodes
    NSSet *DDAIndexes;
    NSSet *intersects;
}
@end

@implementation Scene


-(void)setSegments:(NSInteger)segments{
    cells = [NSMutableArray array];
    points = [NSMutableArray array];
    _segments = segments;
    _cellSize = self.size.width/_segments;
    dda = [[DDA alloc] init];
    [dda setSegments:_segments];
    [dda setCellSize:_cellSize];
    for(int i = 0; i < (int)(self.size.height/_segments) * (int)(self.size.width/_segments); i++){
        Square *square = [[Square alloc] initWithTexture:Nil color:[UIColor colorWithWhite:arc4random()%20/100.+.8 alpha:1.0] size:CGSizeMake(_cellSize, _cellSize)];
        [square setPosition:CGPointMake(_cellSize/2.0+_cellSize*(i%_segments), _cellSize/2.0+_cellSize*(int)(i/_segments))];
        [self addChild:square];
        [cells addObject:square];
    }
    for(int i = 0; i < _segments*4; i++){
        SKSpriteNode *pointNode = [[SKSpriteNode alloc] initWithTexture:nil color:[UIColor blackColor] size:CGSizeMake(5, 5)];
        [self addChild:pointNode];
        [points addObject:pointNode];
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    touchStart = [[touches anyObject] locationInNode:self];
    [self touchesMoved:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    touch = [(UITouch*)[touches anyObject] locationInNode:self];
    NSDictionary *DDADictionary = [dda IndexesAndIntersectionsFromPoint:touchStart To:touch];
    DDAIndexes = [DDADictionary objectForKey:@"indexes"];
    intersects = [DDADictionary objectForKey:@"intersections"];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if(![DDAIndexes isEqualToSet:crossedCells]){
        for(NSNumber *n in crossedCells)
            [cells[[n integerValue]] setHighlighted:NO];
        crossedCells = DDAIndexes;
        for(NSNumber *n in crossedCells)
            [cells[[n integerValue]] setHighlighted:YES];
    }
    NSArray *pointLocations = intersects.allObjects;
    for(int i = 0; i < points.count; i++){
        CGPoint pointLocation;
        if(i < pointLocations.count){
            [points[i] setHidden:NO];
            pointLocation = [[pointLocations objectAtIndex:i] CGPointValue];
        }
        else{
            [points[i] setHidden:YES];
        }
            
        [[points objectAtIndex:i] setPosition:pointLocation];
    }
}

@end
