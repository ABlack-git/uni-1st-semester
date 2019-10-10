package pal;

import java.io.IOException;

public class Main {

    public static void main(String[] args) throws IOException {
        long s1 = System.currentTimeMillis();
        GraphBuilder builder = new GraphBuilder();
        Graph g = builder.build();
        long e1 = System.currentTimeMillis();
        System.out.println("Build time " + (e1 - s1));
        long s2 = System.currentTimeMillis();
        BoruvkaMST mst = new BoruvkaMST(g);
        System.out.println(mst.getMstWeight());
        long e2 = System.currentTimeMillis();
        System.out.println("MST time " + (e2 - s2));
        System.out.println("Total time " + (e2 - s1));
    }
}
