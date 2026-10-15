package z5;

import java.util.Stack;

public class TriCombiningTree {

    TriNode[] leaf;

    public TriCombiningTree(int width) {
        TriNode[] nodes = new TriNode[width + width / 2];
        nodes[0] = new TriNode();
        for (int i = 1; i < nodes.length; i++) {
            nodes[i] = new TriNode(nodes[(i - 1) / 3]);
        }
        leaf = new TriNode[width];
        for (int i = 0; i < leaf.length; i++) {
            leaf[i] = nodes[nodes.length - i - 1];
        }
    }

    public int getAndIncrement(int ThreadID) throws Exception {
        Stack<TriNode> stack = new Stack<>();
        TriNode myLeaf = leaf[ThreadID/3];
        TriNode node = myLeaf;
        // precombining phase
        while (node.precombine()) {
            node = node.parent;
        }
        TriNode stop = node;
        // combining phase
        int combined = 1;
        for (node = myLeaf; node != stop; node = node.parent) {
            combined = node.combine(combined);
            stack.push(node);
        }
        // operation phase
        int prior = stop.op(combined);
        // distribution phase
        while (!stack.empty()) {
            node = stack.pop();
            node.distribute(prior);
        }
        return prior;
    }
}
