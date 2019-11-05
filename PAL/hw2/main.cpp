#include <fstream>
#include <iostream>
#include "Graph.h"

int main(int argc, char **argv) {
//    std::ifstream file(argv[1]);
//    std::cin.rdbuf(file.rdbuf());
    Graph g = buildGraph();
//    g.printGraph();
    g.findScc();
    g.findExpressPath();
    return 0;
}