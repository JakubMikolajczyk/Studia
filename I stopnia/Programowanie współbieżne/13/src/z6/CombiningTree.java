package z6;


import java.util.Stack;

public class CombiningTree {

    ExchangeNode[] leaf;

    public CombiningTree(int width) {
        ExchangeNode[] nodes = new ExchangeNode[2 * width - 1];
        nodes[0] = new ExchangeNode();
        for (int i = 1; i < nodes.length; i++) {
            nodes[i] = new ExchangeNode(nodes[(i - 1) / 2]);
        }
        leaf = new ExchangeNode[width];
        for (int i = 0; i < leaf.length; i++) {
            leaf[i] = nodes[nodes.length - i - 1];
        }
    }

    public int getAndIncrement(int ThreadID) throws Exception {
        Stack<ExchangeNode> stack = new Stack<>();
        ExchangeNode myLeaf = leaf[ThreadID/2];
        ExchangeNode node = myLeaf;
        // precombining phase
        while (node.precombine()) {
            node = node.parent;
        }
        ExchangeNode stop = node;
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
