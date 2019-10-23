#include "Graph.h"

int main() {
    Graph g = buildGraph();
    g.printGraph();
    g.findSccs();
    return 0;
}