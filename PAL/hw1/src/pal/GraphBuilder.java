package pal;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;
import java.util.StringTokenizer;


public class GraphBuilder {
    private Graph g;
    private final BufferedReader bf;
    private int rows;
    private int cols;

    public GraphBuilder() {
        bf = new BufferedReader(new InputStreamReader(System.in));
    }

    public Graph build() throws IOException {
        List<Integer> line = readLine();
        rows = line.get(0);
        cols = line.get(1);
        int p = line.get(2);
        int k = line.get(3);
        g = new Graph(rows, cols, p, k);
        for (int i = 0; i < p; i++) {
            line = readLine();
            g.setPhi(line.get(0), line.get(1), line.get(2));
        }
        for (int j = 0; j < k; j++) {
            line = readLine();
            g.addEdge(line.get(0), line.get(1), line.get(2), line.get(3));
        }
        computeDistance();
        g.initEdges();
        return g;
    }

    private List<Integer> readLine() throws IOException {
        String line = bf.readLine();
        StringTokenizer stringTokenizer = new StringTokenizer(line, " ");
        ArrayList<Integer> integersLine = new ArrayList<>(stringTokenizer.countTokens());
        while (stringTokenizer.hasMoreElements()) {
            integersLine.add(Integer.parseInt(stringTokenizer.nextToken()));
        }
        return integersLine;
    }

    private void computeDistance() {
        boolean[] visited = new boolean[rows * cols];
        int[] distance = new int[rows * cols];
        int[] phiParent = new int[rows * cols];
        Queue<Integer> toVisit = new LinkedList<>(g.getVerticesWithPhi());
        for (int v : g.getVerticesWithPhi()) {
            visited[v] = true;
            phiParent[v] = v;
        }
        while (!toVisit.isEmpty()) {
            int parent = toVisit.poll();
            for (int i = 0; i < 5; i++) {
                int child = g.getNeighbour(parent, i);
                if (child == -1) continue;
                if (!visited[child]) {
                    phiParent[child] = phiParent[parent];
                    visited[child] = true;
                    distance[child] = distance[parent] + 1;
                    if (distance[child] < g.getMinDist(child)) {
                        g.setMinDist(child, distance[child]);
                        g.setMinPhi(child, g.getPhi(phiParent[child]));
                    }
                    toVisit.add(child);
                }
                if (distance[parent] + 1 == g.getMinDist(child) && g.getPhi(phiParent[parent]) < g.getMinPhi(child)) {
                    phiParent[child] = phiParent[parent];
                    g.setMinPhi(child, g.getPhi(phiParent[parent]));
                }
            }
        }
    }
}
