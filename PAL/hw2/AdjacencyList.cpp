#include "AdjacencyList.h"

AdjacencyList::AdjacencyList(int numV) {
    adjacencyList = new std::vector<int>[numV];
    for (int i = 0; i < numV; i++) {
        adjacencyList[i] = std::vector<int>();
    }
}

void AdjacencyList::addEdge(int src, int dest) {
    adjacencyList[src].push_back(dest);
}

std::vector<int> AdjacencyList::getNeighbours(int src) {
    return adjacencyList[src];
}
