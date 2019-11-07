#include <fstream>
#include <iostream>
#include "Graph.h"

int main(int argc, char **argv) {
    Graph g = buildGraph();
    g.findScc();
    g.findExpressPath();
    return 0;
}