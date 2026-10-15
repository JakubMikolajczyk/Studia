namespace p4;

public class z1
{
    public class Singleton1
    {
        private static Singleton1 _instance;

        public static Singleton1 Instance()
        {
            if (_instance == null)
            {
                _instance = new Singleton1();
            }

            return _instance;
        }
    }
    
    public class SingletonThread
    {
        private static Dictionary<int, SingletonThread> _instances = new Dictionary<int, SingletonThread>();

        public static SingletonThread Instance()
        {
            int id = Thread.CurrentThread.ManagedThreadId;
            SingletonThread result;

            if (!_instances.TryGetValue(id, out result))
            {
                result = new SingletonThread();
                _instances.Add(id, result);
            }

            return result;
        }
    }
    
    public class SingletonTime
    {
        private static Dictionary<int, SingletonTime> _instances = new Dictionary<int, SingletonTime>();
        private static DateTime _startTime = DateTime.Now;

        public static SingletonTime Instance()
        {
            int id = (int)DateTime.Now.Subtract(_startTime).TotalSeconds / 5;
            SingletonTime result;

            if (!_instances.TryGetValue(id, out result))
            {
                result = new SingletonTime();
                _instances.Add(id, result);
            }

            return result;
        }
    }
}