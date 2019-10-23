//
// Created by zakharca on 23/10/2019.
//

#include <cstdlib>
#include "AdjacencyList.h"

AdjacencyList::AdjacencyList(int numV) {
    adjacencyList = new NeighboursList *[numV];
    for (int i = 0; i < numV; ++i) {
        adjacencyList[i] = new NeighboursList;
    }
}

void AdjacencyList::addEdge(int src, int dest) {
    adjacencyList[src]->addNeighbour(dest);
}

Node *AdjacencyList::getNeighboursHead(int src) {
    return adjacencyList[src]->head;
}

void NeighboursList::addNeighbour(int value) {
    Node *node = new Node;
    node->vertex = value;
    node->child = nullptr;
    if (head == nullptr) {
        head = node;
        tail = node;
    } else {
        tail->child = node;
        tail = node;
    }
}
