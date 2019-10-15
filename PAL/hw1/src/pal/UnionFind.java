package pal;

public class UnionFind {
    private int[] parents;
    private int[] ranks;
    private int numSets;

    public UnionFind(int numSets) {
        this.numSets = numSets;
        initSets();
        ranks = new int[numSets];
    }

    private void initSets() {
        parents = new int[numSets];
        for (int i = 0; i < numSets; i++) {
            parents[i] = -1;
        }
    }

    public int find(int node) {
        if (parents[node] == -1) {
            return node;
        }
        parents[node] = find(parents[node]);
        return parents[node];
    }

    public void union(int x, int y) {
        if (numSets > 1) {
            int xSet = find(x);
            int ySet = find(y);
            if (ranks[xSet] < ranks[ySet]) {
                parents[xSet] = ySet;
            } else if (ranks[ySet] < ranks[xSet]) {
                parents[ySet] = xSet;
            } else {
                parents[xSet] = ySet;
                ranks[ySet] += 1;
            }
            numSets -= 1;
        }
    }

    public int getNumSets() {
        return numSets;
    }
}
