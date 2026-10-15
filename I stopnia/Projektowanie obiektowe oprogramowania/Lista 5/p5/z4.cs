using System.Collections;

namespace p5;

public class z4
{
    class Program

    {
        /* this is the Comparison<int> to be converted */
        static int IntComparer(int x, int y)
        {
            return x.CompareTo(y);
        }

        static void Main(string[] args)
        {
            ArrayList a = new ArrayList() {1, 5, 3, 3, 2, 4, 3};
        
            /* the ArrayList's Sort method accepts ONLY an IComparer */
            a.Sort(Comparer<int>.Create(IntComparer));
        
            foreach (var val in a)
            {
                Console.WriteLine(val);
            }
        }
    }
}