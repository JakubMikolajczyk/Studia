namespace p6;

public class z3
{
    public abstract class Tree
    {
    }

    public class TreeNode : Tree
    {
        public Tree Left { get; set; }
        public Tree Right { get; set; }
    }

    public class TreeLeaf : Tree
    {
        public int Value { get; set; }
    }

    public class TreeVisitor
    {
        public int Visit(Tree tree)
        {
            if (tree is TreeNode) return this.VisitNode((TreeNode) tree);
            if (tree is TreeLeaf) return this.VisitLeaf((TreeLeaf) tree);
            return 0;
        }

        public virtual int VisitNode(TreeNode node)
        {
            if (node != null)
            {
                return Math.Max(this.Visit(node.Left), this.Visit(node.Right)) + 1;
            }

            return 0;
        }

        public virtual int VisitLeaf(TreeLeaf leaf)
        {
            return 0;
        }
    }

    public static void Main()
    {
        Tree root = new TreeNode()
        {
            Left = new TreeNode()
            {
                Left = new TreeLeaf() {Value = 1},
                Right = new TreeLeaf()
                {
                    Value = 2
                },
            },
            Right = new TreeLeaf() {Value = 3}
        };
    
        TreeVisitor visitor = new TreeVisitor();
        Console.WriteLine(visitor.Visit(root));
    }
}