namespace p3;

public class z1 {
 
    public class Order
    {
        public Order(object products)
        {
        }
    }
    
    public class Client //Creator, Informator Expert
    {
        private List<Order> _orders = new List<Order>();

        public void AddOrder(object products)
        {
            _orders.Add(new Order(products));
        }

        public List<Order> GetAllOrders()
        {
            return _orders;
        } 
    }
    
    // public class Controller
    // {
    //     public static void Main()
    //     {
    //         Console.WriteLine("Enter input");
    //         string input = Console.ReadLine();
    //         //DoSomething(input)
    //         Console.WriteLine(input);
    //     }
    // }
    
    public abstract class Shape
    {
        public abstract int GetArea();
    }
    
    public class Square : Shape
    {
        public override int GetArea()
        {
            return 1;
        }
    }
    
    public class Circle : Shape
    {
        public override int GetArea()
        {
            return 2;
        }
    }
    
}