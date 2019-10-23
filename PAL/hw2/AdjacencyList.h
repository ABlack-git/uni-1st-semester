//
// Created by zakharca on 23/10/2019.
//

#ifndef HW2_ADJACENCYLIST_H
#define HW2_ADJACENCYLIST_H

struct Node {
    int vertex;
    Node *child;
};

class NeighboursList {
public:
    Node *head;
    Node *tail;
    int size;

    NeighboursList() {
        head = nullptr;
        tail = nullptr;
        size = 0;
    }

    void addNeighbour(int value);

};

class AdjacencyList {
private:
    NeighboursList **adjacencyList;

public:
    AdjacencyList(int numV);

    Node *getNeighboursHead(int src);

    void addEdge(int src, int dest);
};


#endif //HW2_ADJACENCYLIST_H
