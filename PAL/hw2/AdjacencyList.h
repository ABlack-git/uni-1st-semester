//
// Created by zakharca on 23/10/2019.
//

#ifndef HW2_ADJACENCYLIST_H
#define HW2_ADJACENCYLIST_H

#include <vector>

class AdjacencyList {
private:
    std::vector<int> *adjacencyList;

public:
    AdjacencyList(int numV);

    std::vector<int> getNeighbours(int src);

    void addEdge(int src, int dest);
};


#endif //HW2_ADJACENCYLIST_H
