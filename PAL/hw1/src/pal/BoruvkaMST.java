package pal;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

public class BoruvkaMST {

    private Graph g;
    private UnionFind sets;
    private int[] cheapest;

    public BoruvkaMST(Graph g) {
        this.g = g;
        sets = new UnionFind(g.getNumVertices());
        cheapest = new int[g.getNumVertices()];
    }

    public int getMstWeight() {
        int mstWeight = 0;
        while (sets.getNumSets() > 1) {
            for (int i = 0; i < cheapest.length; i++) {
                cheapest[i] = -1;
            }
            for (int i = 0; i < g.numEdges; i++) {
                Edge edge = g.getEdge(i);
                int set1 = sets.find(edge.getSrc());
                int set2 = sets.find(edge.getDest());
                if (set1 != set2) {
                    if (cheapest[set1] == -1 || g.getEdge(cheapest[set1]).getWeight() > edge.getWeight()) {
                        cheapest[set1] = i;
                    }
                    if (cheapest[set2] == -1 || g.getEdge(cheapest[set2]).getWeight() > edge.getWeight()) {
                        cheapest[set2] = i;
                    }
                }
            }
            for (int i = 0; i < g.getNumVertices(); i++) {
                if (cheapest[i] == -1) continue;
                Edge edge = g.getEdge(cheapest[i]);
                int set1 = sets.find(edge.getSrc());
                int set2 = sets.find(edge.getDest());
                if (set1 != set2) {
                    mstWeight += edge.getWeight();
                    sets.union(set1, set2);
                }
            }
        }
        return mstWeight;
    }
}
