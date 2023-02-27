namespace ConsoleApp1;

public class z3
{
    public interface IDataStrategy
    {
        void connect();
        void getData();
        void processData();
        void close();
    }
    public class DataAccessHandler
    {
        private IDataStrategy _strategy;

        public DataAccessHandler(IDataStrategy strategy)
        {
            _strategy = strategy;
        }

        public void Execute()
        {
            _strategy.connect();
            _strategy.getData();
            _strategy.processData();
            _strategy.close();
        }
    }
    
    public class ColumnSum : IDataStrategy
    {
        public void connect()
        {
            // połączenie do sql
            throw new NotImplementedException();
        }

        public void getData()
        {
            // wzięcie kolumn
            throw new NotImplementedException();
        }

        public void processData()
        {
            // policzenie sumy
            throw new NotImplementedException();
        }

        public void close()
        {
            // zamkniecie połączenia
            throw new NotImplementedException();
        }
    }
    
    public class XML : IDataStrategy
    {
        public void connect()
        {
            // połączenie do pliku xml
            throw new NotImplementedException();
        }

        public void getData()
        {
            // pobranie wezłów
            throw new NotImplementedException();
        }

        public void processData()
        {
            // znalezienie wezła o najdłuższej długości
            throw new NotImplementedException();
        }

        public void close()
        {
            // zamknięcie pliku
            throw new NotImplementedException();
        }
    }

    static void Main()
    {
        DataAccessHandler sql = new DataAccessHandler(new ColumnSum());
        sql.Execute();
        DataAccessHandler XML = new DataAccessHandler(new XML());
        XML.Execute();
    }
}