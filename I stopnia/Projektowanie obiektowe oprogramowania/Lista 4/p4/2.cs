namespace p4;

public class z2 {
    
    public interface IShape
    {
        
    }
    
    public interface IShapeFactoryWorker
    {
        bool AcceptsParameters(string param);
        IShape Create(params object[] parameters);
    }
    
    public class Square : IShape
    {
        
    }
    
    public class SquareWorker : IShapeFactoryWorker
    {
        public bool AcceptsParameters(string param)
        {
            return param == "Square";
        }

        public IShape Create(params object[] parameters)
        {
            return new Square();
        }
    }
    
    
    public class ShapeFactory
    {
        private List<IShapeFactoryWorker> _workers = new List<IShapeFactoryWorker>();

        public ShapeFactory()
        {
            _workers.Add(new SquareWorker());
        }
        
        public void RegisterWorker( IShapeFactoryWorker worker ) {
            _workers.Add(worker);
        }
        
        public IShape CreateShape( string ShapeName, params object[] parameters ) {
            
            foreach (var worker in _workers)
            {
                if (worker.AcceptsParameters(ShapeName))
                {
                    return worker.Create(parameters);
                }
            }

            throw new ArgumentNullException();
        }
    }
    
    public class Rectangle : IShape
    {
        
    }
    
    public class RectangleFactoryWorker : IShapeFactoryWorker
    {
        public bool AcceptsParameters(string param)
        {
            return param == "Rectangle";
        }

        public IShape Create(params object[] parameters)
        {
            return new Rectangle();
        }
    }
}