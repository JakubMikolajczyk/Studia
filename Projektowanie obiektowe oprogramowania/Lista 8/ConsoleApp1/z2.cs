namespace ConsoleApp1;

public class z2
{
    public abstract class DataAccessHandler
    {
        public abstract void connect();
        public abstract void getData();
        public abstract void processData();
        public abstract void close();

        public void Execute()
        {
            this.connect();
            this.getData();
            this.processData();
            this.close();
        }
    }
    
    public class ColumnSum : DataAccessHandler
    {
        public override void connect()
        {
            // połączenie do sql
            throw new NotImplementedException();
        }

        public override void getData()
        {
            // wzięcie kolumn
            throw new NotImplementedException();
        }

        public override void processData()
        {
            // policzenie sumy
            throw new NotImplementedException();
        }

        public override void close()
        {
            // zamkniecie połączenia
            throw new NotImplementedException();
        }
    }
    
    public class XML : DataAccessHandler
    {
        public override void connect()
        {
            // połączenie do pliku xml
            throw new NotImplementedException();
        }

        public override void getData()
        {
            // pobranie wezłów
            throw new NotImplementedException();
        }

        public override void processData()
        {
            // znalezienie wezła o najdłuższej długości
            throw new NotImplementedException();
        }

        public override void close()
        {
            // zamknięcie pliku
            throw new NotImplementedException();
        }
    }

    static void Main()
    {
        DataAccessHandler sql = new ColumnSum();
        sql.Execute();
        DataAccessHandler XML = new XML();
        XML.Execute();
    }
}