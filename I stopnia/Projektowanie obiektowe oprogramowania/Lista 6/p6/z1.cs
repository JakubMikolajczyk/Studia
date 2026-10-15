namespace p6;

public class z1
{
    public interface ILogger
    {
        void Log(string Message);
    }

    public class ConsoleLogger: ILogger
    {
        public void Log(string Message)
        {
            Console.WriteLine("Console: " + Message);
        }
    }
    
    public class NoneLogger : ILogger
    {
        public void Log(string Message)
        {
        }
    }
    
    public class FileLogger : ILogger
    {
        public void Log(string Message)
        {
            Console.WriteLine("file save: " + Message);
        }
    }
    
    public enum LogType
    {
        None,
        Console,
        File
    }

    public class LoggerFactory
    {
        public static ILogger GetLogger(LogType LogType, string Parameters = null)
        {
            switch (LogType)
            {
                case LogType.Console:
                    return new ConsoleLogger();
                case LogType.File:
                    return new FileLogger();
                case LogType.None:
                    return new NoneLogger();
            }

            return new NoneLogger();
        }

    }

    // public static void Main()
    // {
    //     
    //     ILogger logger1 = LoggerFactory.GetLogger( LogType.File, "C:\foo.txt" );
    //     logger1.Log( "foo bar" ); // logowanie do pliku
    //     ILogger logger2 = LoggerFactory.GetLogger( LogType.None );
    //     logger2.Log( "qux" );     // brak logowania
    //     
    //     ILogger logger3 = LoggerFactory.GetLogger( LogType.Console );
    //     logger3.Log( "dfsdgsd" );     // brak logowania
    // }
}