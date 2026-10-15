namespace p6;

public class z2
{
    public class Context
    {
        private Dictionary<string, bool> dic = new Dictionary<string, bool>();

        public bool GetValue(string VariableName)
        {
            bool ret;
            if (dic.TryGetValue(VariableName, out ret))
            {
                return ret;
            }

            throw new ArgumentException();
        }

        public void SetValue(string VariableName, bool Value)
        {
            dic.Add(VariableName, Value);
        }
    }

    public abstract class AbstractExpression
    {
        public abstract bool Interpret(Context context);
    }

    public abstract class BinaryExpression : AbstractExpression
    {
        protected AbstractExpression Left;
        protected AbstractExpression Right;

        protected BinaryExpression(AbstractExpression left, AbstractExpression right)
        {
            this.Left = left;
            this.Right = right;
        }
    }
    
    public abstract class UnaryExpression : AbstractExpression
    {
        protected AbstractExpression Expression;

        protected UnaryExpression(AbstractExpression expression)
        {
            Expression = expression;
        }
    }

    public class CONST : AbstractExpression
    {
        private bool Value;

        public CONST(bool value)
        {
            Value = value;
        }

        public override bool Interpret(Context context)
        {
            return Value;
        }
    }
    
    public class Var : AbstractExpression
    {
        private string VarName;

        public Var(string varName)
        {
            VarName = varName;
        }

        public override bool Interpret(Context context)
        {
            return context.GetValue(VarName);
        }
    }
    
    public class AND : BinaryExpression
    {
        public AND(AbstractExpression left, AbstractExpression right) : base(left, right) { }

        public override bool Interpret(Context context)
        {
            return Left.Interpret(context) && Right.Interpret(context);
        }
    }
    
    public class OR : BinaryExpression
    {
        public OR(AbstractExpression left, AbstractExpression right) : base(left, right) { }

        public override bool Interpret(Context context)
        {
            return Left.Interpret(context) || Right.Interpret(context);
        }
    }
    
    public class NOT : UnaryExpression
    {
        public NOT(AbstractExpression expression) : base(expression) { }

        public override bool Interpret(Context context)
        {
            return !Expression.Interpret(context);
        }
    }
    
}