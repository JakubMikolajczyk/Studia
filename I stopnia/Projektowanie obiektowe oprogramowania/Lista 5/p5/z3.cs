namespace p5;

public class z3
{
    class Foo
    {
        public virtual void DoSomething()
        {
            
        }
    }

    class FooLoginProxy : Foo
    {
        private Foo _foo;
        
        public FooLoginProxy()
        {
            this._foo = new Foo();
        }
        
        public override void DoSomething()
        {
        //     LogStart("Start doing something");
        //     _foo.DoSomething();
        //     LogEnd("Complete doing something");
        }
    }

    class FooProtectProxy : Foo
    {
        private Foo _foo;
        
        public FooProtectProxy()
        {
            this._foo = new Foo();
        }
        
        public override void DoSomething()
        {
            TimeSpan time = DateTime.Now.TimeOfDay;
            
            if (time > new TimeSpan(8, 00, 00)
                && time < new TimeSpan(22, 00, 00))
            {
                _foo.DoSomething();
            }
            else
            {
                throw new Exception();
            }
        }
        
    }
}