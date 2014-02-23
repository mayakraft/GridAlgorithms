//
//  View.h
//  Squares
//
//  Created by Robby Kraft on 10/22/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface CellScene:SKScene
@property (nonatomic, readonly) int rows;
@property (nonatomic, readonly) int columns;
@property (nonatomic, readonly) int numCells;
@property (nonatomic, readonly) CGFloat cellSize;

-(id) initWithSize:(CGSize)size Columns:(int)c;

@end
