package pal;

import java.util.*;

public class Graph {

    private List<Integer> verticesWithPhi;
    private Edge[] edges;
    private int[][] adjacencyList;
    private int[] vertexPhi;
    private int[] minDist;
    private int[] minPhi;
    private int cols;
    private int rows;
    private int numVertices;
    final int numEdges;

    public Graph(int rows, int cols, int p, int k) {
        numVertices = rows * cols;
        this.cols = cols;
        this.rows = rows;
        minDist = new int[numVertices];
        minPhi = new int[numVertices];
        vertexPhi = new int[numVertices];
        adjacencyList = new int[numVertices][5];
        numEdges = 2 * numVertices - rows - cols + k;
        edges = new Edge[numEdges];
        verticesWithPhi = new ArrayList<>(p);
        initAdjListAndVertices();
    }

    public void initEdges() {
        int edgeNumber = 0;
        for (int src = 0; src < numVertices; src++) {
            for (int j = 0; j < 5; j++) {
                int dest = adjacencyList[src][j];
                if (dest == -1) continue;
                if (dest < src) continue;
                edges[edgeNumber++] = new Edge(src, dest, computeWeight(src, dest));
            }
        }
    }

    private void initAdjListAndVertices() {
        for (int i = 0; i < numVertices; i++) {
            int r = (i / cols) + 1;
            int c = (i % cols) + 1;
            minDist[i] = Integer.MAX_VALUE;
            minPhi[i] = Integer.MAX_VALUE;
            for (int j = 0; j < 5; j++) {
                adjacencyList[i][j] = -1;
            }
            int index = 0;
            if (r > 1) {
                addToAdjList(i, toRowOrderOneBased(r - 1, c, cols), index++);
            }
            if (r < rows) {
                addToAdjList(i, toRowOrderOneBased(r + 1, c, cols), index++);
            }
            if (c > 1) {
                addToAdjList(i, toRowOrderOneBased(r, c - 1, cols), index++);
            }
            if (c < cols) {
                addToAdjList(i, toRowOrderOneBased(r, c + 1, cols), index);
            }
        }
    }

    public int getNumVertices() {
        return numVertices;
    }

    public int computeWeight(int src, int dest) {
        return minDist[src] + minDist[dest] + Math.abs(minPhi[src] - minPhi[dest]);
    }

    private void addToAdjList(int src, int dest, int index) {
        adjacencyList[src][index] = dest;
    }

    private void addToAdjList(int src, int dest) {
        int i = 0;
        while (adjacencyList[src][i] != -1) {
            i++;
        }
        adjacencyList[src][i] = dest;
    }

    public void addEdge(int r1, int c1, int r2, int c2) {
        int src = toRowOrderOneBased(r1, c1, cols);
        int dest = toRowOrderOneBased(r2, c2, cols);
        addToAdjList(src, dest);
        addToAdjList(dest, src);
    }

    public int getNeighbour(int src, int index) {
        return adjacencyList[src][index];
    }

    public Edge getEdge(int edge) {
        return edges[edge];
    }

    public int[] getVertexNeighbours(int index) {
        return adjacencyList[index];
    }

    public int getMinDist(int index) {
        return minDist[index];
    }

    public void setMinDist(int index, int value) {
        minDist[index] = value;
    }

    public int getMinPhi(int index) {
        return minPhi[index];
    }

    public void setMinPhi(int index, int value) {
        minPhi[index] = value;
    }

    public int getPhi(int index) {
        return vertexPhi[index];
    }

    public List<Integer> getVerticesWithPhi() {
        return verticesWithPhi;
    }

    public void setPhi(int r, int c, int phi) {
        int index = toRowOrderOneBased(r, c, cols);
        minPhi[index] = phi;
        vertexPhi[index] = phi;
        verticesWithPhi.add(index);
        minDist[index] = 0;
    }

    public int toRowOrderOneBased(int row, int col, int width) {
        return width * (row - 1) + (col - 1);
    }
}
