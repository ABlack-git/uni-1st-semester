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

Graph::Graph(int numV) : adjacencyList(numV), topSortedV() {
    numVertices = numV;
    maxPathLength = INT_MIN;
    maxPathCost = INT_MIN;
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
}

void Graph::sccDfs(int currentV, std::stack<int> &stack, bool *onStack, int &time) {
    stack.push(currentV);
    onStack[currentV] = true;
    vertices[currentV].desc = vertices[currentV].lowLink = time++;
    for (int child : adjacencyList.getNeighbours(currentV)) {
        if (vertices[child].desc == UNVISITED) {
            sccDfs(child, stack, onStack, time);
            vertices[currentV].lowLink = std::min(vertices[currentV].lowLink, vertices[child].lowLink);
        } else if (onStack[child]) {
            vertices[currentV].lowLink = std::min(vertices[currentV].lowLink, vertices[child].desc);
        }
    }
    if (vertices[currentV].desc == vertices[currentV].lowLink) {
        auto costStack = std::stack<int>();
        while (!stack.empty()) {
            int vertex = stack.top();
            stack.pop();
            onStack[vertex] = false;
            topSortedV.push_back(vertex);
            costStack.push(vertex);
            vertices[vertex].scc = currentV;
            if (vertex == currentV) {
                break;
            }
        }
        int cost = costStack.size();
        while (!costStack.empty()) {
            vertices[costStack.top()].cost = cost;
            costStack.pop();
        }
    }
}

void Graph::findExpressPath() {
    Path expressPaths[numVertices];
    //traverse topSorted in reverse
    for (auto rit = topSortedV.rbegin(); rit != topSortedV.rend(); rit++) {
        int parent = *rit;
        if (expressPaths[parent].pathCost == INT_MIN) {
            expressPaths[parent].pathCost = vertices[parent].cost;
            expressPaths[parent].pathLength = 0;
        }
        for (int child : adjacencyList.getNeighbours(parent)) {
            if (vertices[parent].scc == vertices[child].scc || vertices[child].cost < vertices[parent].cost) {
                continue;
            }
            int cost = expressPaths[parent].pathCost + vertices[child].cost;
            int length = expressPaths[parent].pathLength + 1;
            if (cost > expressPaths[child].pathCost ||
                (cost == expressPaths[child].pathCost && length > expressPaths[child].pathLength)) {
                expressPaths[child].pathCost = cost;
                expressPaths[child].pathLength = length;
                if (expressPaths[child].pathCost > maxPathCost ||
                    (expressPaths[child].pathCost == maxPathCost && expressPaths[child].pathLength > maxPathLength)) {
                    maxPathCost = expressPaths[child].pathCost;
                    maxPathLength = expressPaths[child].pathLength;
                }
            }
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
    Graph g = Graph(numV);
    for (int i = 0; i < numE; i++) {
        p = readLine();
        g.addEdge(p.first, p.second);
    }
    return g;
}



