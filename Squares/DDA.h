//
//  DDA.h
//  Squares
//
//  Created by Robby Kraft on 10/23/13.
//  Copyright (c) 2013 Robby Kraft. All rights reserved.
//

#import <Foundation/Foundation.h>

// Digital Differential Analyzer

@interface DDA : NSObject
@property (nonatomic) NSInteger segments;
@property (nonatomic) CGFloat cellSize;
@property (nonatomic) CGFloat cellSizeX;
@property (nonatomic) CGFloat cellSizeY;

-(NSDictionary*)IndexesAndIntersectionsFromPoint:(CGPoint)start To:(CGPoint)end;

@end
