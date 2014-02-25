//
//  AStar.cpp
//  Squares
//
//  Created by Robby Kraft on 2/21/14.
//  Copyright (c) 2014 Robby Kraft. All rights reserved.
//

#include "AStar.h"

#define MOVE_COST 1

// 2D array orientation column-first. indexes increment by 1 through columns, and rows are reached by steps of num_columns

void AStar::setup(int c, int r, bool obstacles[]){

    delete obstacleCells;
    delete hValues;
    delete gValues;

    columns = c;
    rows = r;
    obstacleCells = (bool*)malloc(sizeof(bool)*columns*rows);
    for(int i = 0; i < columns*rows; i++)
        obstacleCells[i] = obstacles[i];
    hValues = (int*)malloc(sizeof(int)*columns*rows);
    gValues = (int*)malloc(sizeof(int)*columns*rows);
    fValues = (int*)malloc(sizeof(int)*columns*rows);
    openList = (bool*)malloc(sizeof(bool)*columns*rows);
    closedList = (bool*)malloc(sizeof(bool)*columns*rows);
    parentIndex = (int*)malloc(sizeof(int)*columns*rows);
}

void AStar::setObstacleCellArray(bool obstacles[]){
    delete obstacleCells;
    obstacleCells = (bool*)malloc(sizeof(bool)*columns*rows);
    for(int i = 0; i < columns*rows; i++)
        obstacleCells[i] = obstacles[i];
}

void AStar::convertIndexToColumnRow(int index, int *column, int *row){
    *column = index%columns;
    *row = (int)index/columns;
}

void AStar::pathFromAtoB(int A, int B, int pathArray[], int *sizeOfArray){
    bool found;
    if(A == B){
        found = true;
        pathArray[0] = A;
        *sizeOfArray = 1;
        return;
    }
    
    found = false;
    
    for(int i = 0; i < columns*rows; i++){
        openList[i] = false;
        closedList[i] = false;
    }
//    int start[2] = {A%columns, (int)A/columns};
    int end[2] = {B%columns, (int)B/columns};
    for(int c = 0; c < columns; c++){
        for(int r = 0; r < rows; r++){
            hValues[c+r*columns] = abs(end[0]-c) + abs(end[1]-r);
        }
    }
//    printf("\n");
//    for(int c = 0; c < columns; c++){
//        for(int r = 0; r < rows; r++){
//            printf("%d ",hValues[c+r*columns]);
//        }
//        printf("\n");
//    }
    
    // check neighbors, add children to cell, when finished, close this cell
    int step, stepRow, stepColumn, neighborIndex[4];
    gValues[A] = 0;
    openList[A] = true;
    
    step = A;
    int iterations = 0;
    while(!found && iterations < 1000){
    // check if neighbors exist, or are out of bounds.
        convertIndexToColumnRow(step, &stepColumn, &stepRow);
        neighborIndex[0] = -1;
        neighborIndex[1] = -1;
        neighborIndex[2] = -1;
        neighborIndex[3] = -1;
        if(stepColumn > 0) neighborIndex[0] = step - 1;
        if(stepColumn < columns-1) neighborIndex[1] = step + 1;
        if(stepRow > 0) neighborIndex[2] = step - columns;
        if(stepRow < rows-1) neighborIndex[3] = step + columns;
        // if neighbors exist, and are on the open list, calculate cost and set their parent
        for(int i = 0; i < 4; i++){
            if(neighborIndex[i] != -1 && !openList[neighborIndex[i]] && !closedList[neighborIndex[i]] && !obstacleCells[neighborIndex[i]] ){
                gValues[neighborIndex[i]] = gValues[step] + MOVE_COST;
                fValues[neighborIndex[i]] = gValues[neighborIndex[i]] + hValues[neighborIndex[i]];
                parentIndex[neighborIndex[i]] = step;
                openList[neighborIndex[i]] = true;
            }
        }
        openList[step] = false;
        closedList[step] = true;
        int smallestFValue = INT_MAX;
        int smallestIndex = -1;
        for(int i = 0; i < columns*rows; i++){
            if(openList[i] && fValues[i] < smallestFValue){
                smallestFValue = fValues[i];
                smallestIndex = i;
            }
        }
        // repeat with step = smallestIndex;
        if(smallestIndex == -1) {
            printf("\nfail: cannot reach target cell\n");
            return;
        }
        step = smallestIndex;
        if(smallestIndex == B){
//            printf("\n*******\n FOUND\n*******\n");
            // trace parents back to point A, build a list along the way
            int i = 0;
            int pathIndex = B;
            do {
                pathArray[i] = pathIndex;
                pathIndex = parentIndex[pathIndex];
                i++;
            } while (pathIndex != A && i < 2000);
            *sizeOfArray = i;
//            for(int j = 0; j < *sizeOfArray; j++)
//                printf("%d ",pathArray[j]);
//            printf("\n");
            return;
        }
        iterations++;
    }

    printf("returning cause iterations got to %d\n",iterations);
    return;
    
}