//
// Created by zakharca on 23/10/2019.
//
#include <string>
#include <iostream>
#include <sstream>
#include <cstdio>
#include <stack>

#include "Graph.h"
#include "utils.h"

#define UNVISITED -1

void Graph::addEdge(int src, int dest) {
    adjacencyList.addEdge(src, dest);
}

void Graph::printGraph() {
    for (int i = 0; i < numVertices; i++) {
        Node *node = adjacencyList.getNeighboursHead(i);
        printf("Neighbours of %d:\n", i);
        while (node != nullptr) {
            printf("%d->", node->vertex);
            node = node->child;
        }
        printf("\n");
    }
}

void Graph::findSccs() {
    auto *sccStack = new std::stack<int>();
    bool *onStack = new bool[numVertices];
    int time = 0;

    for (int i = 0; i < numVertices; i++) {
        if (vertices[i].desc == UNVISITED) {
            sccDfs(i, sccStack, onStack, time);
        }
    }
    printf("sccNum=%d", sccNum);

}

void Graph::sccDfs(int parent, std::stack<int> *stack, bool *onStack, int time) {
    stack->push(parent);
    onStack[parent] = true;
    vertices->desc = vertices->lowLink = time++;
    Node *node = adjacencyList.getNeighboursHead(parent);
    while (node != nullptr) {
        int child = node->vertex;
        if (vertices[child].desc == UNVISITED) {
            sccDfs(child, stack, onStack, time);
        }
        if (onStack[child]) {
            vertices[child].lowLink = std::min(vertices[child].lowLink, vertices[parent].lowLink);
        }
        node = node->child;
    }
    if (vertices[parent].desc == vertices[parent].lowLink) {
        while (!stack->empty()) {
            int id = stack->top();
            stack->pop();
            onStack[id] = false;
            vertices[id].lowLink = vertices[parent].desc;
            if (id == parent) break;
        }
        sccNum++;
    }
}


Pair readLine() {
    Pair pair{};
    std::string line;
    std::getline(std::cin, line);
    std::istringstream iss(line);
    iss >> pair.first;
    iss >> pair.second;
    return pair;
}

Graph buildGraph() {
    Pair p = readLine();
    int numV = p.first;
    int numE = p.second;
    Graph g = Graph(numV, numE);
    for (int i = 0; i < numE; i++) {
        p = readLine();
        g.addEdge(p.first, p.second);
    }
    return g;
}



