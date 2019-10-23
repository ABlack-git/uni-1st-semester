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

class Graph {
private:
    int numVertices;
    int numEdges;
    int sccNum;
    Vertex *vertices;
    AdjacencyList adjacencyList;

    void sccDfs(int parent, std::stack<int> *stack, bool *onStack, int time);

public:
    Graph(int numV, int numE) : adjacencyList(numV) {
        numVertices = numV;
        numEdges = numE;
        sccNum = 0;
        vertices = new Vertex[numVertices];
    }

    void printGraph();

    void addEdge(int src, int dest);

    void findSccs();
};

Graph buildGraph();


#endif //HW2_GRAPH_H
