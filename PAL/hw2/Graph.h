//
// Created by zakharca on 23/10/2019.
//

#ifndef HW2_GRAPH_H
#define HW2_GRAPH_H

#include <stack>
#include "AdjacencyList.h"

struct Vertex {
    int desc = -1;
    int lowLink = -1;
    int cost = -1;
};

struct Path {
    int pathCost = 0;
    int pathLength = 0;
};

class Graph {
private:
    int numVertices;
    int numEdges;
    int sccNum;
    int maxPathCost;
    int maxPathLength;
    Vertex *vertices;
    AdjacencyList adjacencyList;
    std::vector<int> topSortedV;

    void sccDfs(int currentV, std::stack<int> &stack, bool *onStack, int &time);

    void expressPathDfs(int vertex, bool *visited, Path *expressPaths);

public:
    Graph(int numV, int numE);

    void printGraph();

    void addEdge(int src, int dest);

    void findScc();

    void findExpressPath();
};

Graph buildGraph();


#endif //HW2_GRAPH_H
