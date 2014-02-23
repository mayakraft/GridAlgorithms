//
//  AStar.h
//  Squares
//
//  Created by Robby Kraft on 2/21/14.
//  Copyright (c) 2014 Robby Kraft. All rights reserved.
//

#ifndef __Squares__AStar__
#define __Squares__AStar__

#include <iostream>

class AStar{
    
public:
    void setup(int width, int height, int *obstacleCells, int sizeOfArray);
    void setObstacleCellArray(int *obstacleCellArray, int sizeOfArray);

    void pathFromAtoB(int A, int B, int *pathArray, int *sizeOfArray);

private:
    int width;
    int height;
    int *obstacleCells;

};

#endif /* defined(__Squares__AStar__) */
