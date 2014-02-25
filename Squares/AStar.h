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
    void setup(int columns, int rows, int obstacleCells[]);
    void setObstacleCellArray(int obstacleCellArray[]);

    void pathFromAtoB(int A, int B, int pathArray[], int *sizeOfArray);

private:
    int columns;
    int rows;
    bool *obstacleCells = NULL;
    int obstacleCellArrayLength;

    int *hValues = NULL;  // (heuristic) manhattan distance to end point
    int *gValues = NULL;  // move cost from start point
    int *fValues = NULL;  // g + h values
    
    bool *openList = NULL;
    bool *closedList = NULL;
    
    int *parentIndex = NULL;
    
    void convertIndexToColumnRow(int index, int *column, int *row);

};

#endif /* defined(__Squares__AStar__) */
