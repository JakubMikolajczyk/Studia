namespace p3;

public class z3 {
    
    public class Item
    {
        private double _price;
        private string _name;

        public Item(double price)
        {
            _price = price;
        }

        public string Name
        {
            get => _name;
            set => _name = value;
        }

        public double Price
        {
            get => _price;
            set => _price = value;
        }
    }
    
    public interface ITaxCalculator
    {
        double CalculateTax(double price);
    }
    
    public interface ITaxCalculatorWorker
    {
        bool AcceptsParameters(string param);
        ITaxCalculator Create(); 
    }
    
    public class CashRegister
    {
        private List<ITaxCalculatorWorker> _taxCalculators = new List<ITaxCalculatorWorker>();

        public double CalculatePrice(string Vat, Item[] Items)
        {
            foreach (var taxCalculator in _taxCalculators)
            {
                if (taxCalculator.AcceptsParameters(Vat))
                {
                    ITaxCalculator calculator = taxCalculator.Create();
                    double price = 0;
                    foreach (var item in Items)
                    {
                        price += item.Price + calculator.CalculateTax(item.Price);
                    }

                    return price;
                }
            }

            throw new ArgumentNullException();
        }
        
        public void newTax(ITaxCalculatorWorker calculatorWorker)
        {
            _taxCalculators.Add(calculatorWorker);
        }
        
    }
    
    public class ATax : ITaxCalculator
    {
        public double CalculateTax(double price)
        {
            return 0;
        }
    }
    
    public class ATaxWorker : ITaxCalculatorWorker
    {
        public bool AcceptsParameters(string param)
        {
            return param == "A";
        }

        public ITaxCalculator Create()
        {
            return new ATax();
        }
    }
    
    public class BTax : ITaxCalculator
    {
        public double CalculateTax(double price)
        {
            return price * 0.22;
        }
    }
    
    public class BTaxWorker : ITaxCalculatorWorker
    {
        public bool AcceptsParameters(string param)
        {
            return param == "B";
        }

        public ITaxCalculator Create()
        {
            return new BTax();
        }
    }

    public static void Main()
    {
        Item[] items = new Item[10];
        for (int i = 0; i < 10; i++)
        {
            items[i] = new Item(i * 1.0);
        }

        CashRegister cashRegister = new CashRegister();
        cashRegister.newTax(new ATaxWorker());
        cashRegister.newTax(new BTaxWorker());
        
        Console.WriteLine(cashRegister.CalculatePrice("A", items));
        Console.WriteLine(cashRegister.CalculatePrice("B", items));
    }
    
}