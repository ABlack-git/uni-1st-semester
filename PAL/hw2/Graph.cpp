//
// Created by zakharca on 23/10/2019.
//
#include <iostream>
#include <sstream>
#include <cstdio>
#include <stack>

#include "Graph.h"
#include "utils.h"

#define UNVISITED -1

Graph::Graph(int numV, int numE) : adjacencyList(numV), topSortedV() {
    numVertices = numV;
    numEdges = numE;
    sccNum = 0;
    maxPathLength = -1;
    maxPathCost = 0;
    vertices = new Vertex[numVertices];
}

void Graph::addEdge(int src, int dest) {
    adjacencyList.addEdge(src, dest);
}

void Graph::printGraph() {
    for (int i = 0; i < numVertices; i++) {
        std::vector<int> neighbours = adjacencyList.getNeighbours(i);
        printf("Neighbours of %d:\n", i);
        for (int vertex : neighbours) {
            printf("%d-->", vertex);
        }
        printf("\n");
    }
}

void Graph::findScc() {
    auto sccStack = std::stack<int>();
    bool *onStack = new bool[numVertices];
    for (int i = 0; i < numVertices; i++) {
        onStack[i] = false;
    }
    int time = 0;
    for (int i = 0; i < numVertices; i++) {
        if (vertices[i].desc == UNVISITED) {
            sccDfs(i, sccStack, onStack, time);
        }
    }
    for (auto rit = topSortedV.rbegin(); rit != topSortedV.rend(); rit++) {
        std::cout << *rit << std::endl;
    }
    printf("sccNum=%d\n", sccNum);

}

void Graph::sccDfs(int currentV, std::stack<int> &stack, bool *onStack, int &time) {
    stack.push(currentV);
    onStack[currentV] = true;
    vertices[currentV].desc = time;
    vertices[currentV].lowLink = time++;
    std::vector<int> neighbours = adjacencyList.getNeighbours(currentV);
    for (int child : neighbours) {
        if (vertices[child].desc == UNVISITED) {
            sccDfs(child, stack, onStack, time);
            vertices[currentV].lowLink = std::min(vertices[currentV].lowLink, vertices[child].lowLink);
        } else if (onStack[child]) {
            vertices[currentV].lowLink = std::min(vertices[child].lowLink, vertices[currentV].desc);
        }
    }
    if (vertices[currentV].desc == vertices[currentV].lowLink) {
        std::stack<int> costStack = std::stack<int>();
        while (!stack.empty()) {
            int id = stack.top();
            topSortedV.push_back(id);
            costStack.push(id);
            onStack[id] = false;
            vertices[id].lowLink = vertices[currentV].desc;
            stack.pop();
            if (id == currentV) {
                break;
            }
        }
        int cost = costStack.size();
        while (!costStack.empty()) {
            int id = costStack.top();
            vertices[id].cost = cost;
            costStack.pop();
        }
        sccNum++;
    }
}

void Graph::findExpressPath() {
    bool *explored = new bool[numVertices];
    Path *expressPaths = new Path[numVertices];
    for (int i = 0; i < numVertices; i++) {
        explored[i] = false;
    }
    for (auto rit = topSortedV.rbegin(); rit != topSortedV.rend(); rit++) {
        int i = *rit;
        if (!explored[i]) {
            expressPathDfs(i, explored, expressPaths);
        }
    }
    printf("%d %d\n", maxPathCost, maxPathLength);
}

void Graph::expressPathDfs(int currentV, bool *visited, Path *expressPaths) {
    visited[currentV] = true;
    expressPaths[currentV].pathLength = 0;
    expressPaths[currentV].pathCost = vertices[currentV].cost;
    for (int child : adjacencyList.getNeighbours(currentV)) {
        if (vertices[child].cost < vertices[currentV].cost || vertices[currentV].lowLink == vertices[child].lowLink) {
            continue;
        }
        if (!visited[child]) {
            expressPathDfs(child, visited, expressPaths);
        }
        int length = expressPaths[child].pathLength + 1;
        int cost = expressPaths[child].pathCost + vertices[currentV].cost;
        if (cost > expressPaths[currentV].pathCost ||
            (cost == expressPaths[currentV].pathCost && length > expressPaths[currentV].pathLength)) {
            expressPaths[currentV].pathCost = cost;
            expressPaths[currentV].pathLength = length;
        }
    }
    if (expressPaths[currentV].pathCost > maxPathCost ||
        (expressPaths[currentV].pathCost == maxPathCost && expressPaths[currentV].pathLength > maxPathLength)) {
        maxPathCost = expressPaths[currentV].pathCost;
        maxPathLength = expressPaths[currentV].pathLength;
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



