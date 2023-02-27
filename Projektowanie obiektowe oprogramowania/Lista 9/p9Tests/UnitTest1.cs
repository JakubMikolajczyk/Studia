using System;
using NUnit.Framework;

namespace p9Tests;

public interface AbstractFoo
{
}

public class Foo : AbstractFoo
{
    private Bar _bar;
    [DependencyConstructor] 
    public Foo()
    {
        this._bar = new Bar();
    }
}

public class Bar : AbstractFoo
{
    public Bar()
    {
    }
}

public class Qux : AbstractFoo
{
    public Qux()
    {
    }

    public Qux(Foo f)
    {
    }
}

public class CycleClass1
{
    public CycleClass1()
    {
    }

    public CycleClass1(CycleClass1 c)
    {
    }
}

public class CycleClass2
{
    public CycleClass2()
    {
    }

    public CycleClass2(CycleClass1 c)
    {
    }
}


public class A
{
    public B b;

    public A(B b)
    {
        this.b = b;
    }
}

public class B
{
}

public class X
{
    public X(Y d, String s)
    {
    }
}

public class Y
{
}

public class A2
{
    public B2 b;
    public IC c;

    public A2(B2 b, IC c)
    {
        this.b = b;
        this.c = c;
    }
}

public class B2
{
}

public interface IC
{
}

public class C : IC
{
}

public class Tests
{
    [Test]
    public void SingletonTest()
    {
        SimpleContainer container = new SimpleContainer();
        container.RegisterType<Foo>(true);
        Foo f1 = container.Resolve<Foo>();
        Foo f2 = container.Resolve<Foo>();
        Assert.AreEqual(f1, f2);
    }

    [Test]
    public void InterfaceTest()
    {
        SimpleContainer container = new SimpleContainer();
        container.RegisterType<AbstractFoo, Foo>(false);
        AbstractFoo f1 = container.Resolve<AbstractFoo>();

        container.RegisterType<AbstractFoo, Bar>(false);
        AbstractFoo f2 = container.Resolve<AbstractFoo>();
        Assert.AreEqual(f1.GetType(), typeof(Foo));
        Assert.AreEqual(f2.GetType(), typeof(Bar));
    }

    [Test]
    public void UnregisteredConcreteType()
    {
        SimpleContainer container = new SimpleContainer();
        Foo f1 = container.Resolve<Foo>();
        Assert.IsNotNull(f1);
    }

    [Test]
    public void UnregisteredInterface()
    {
        SimpleContainer container = new SimpleContainer();
        Assert.Throws<Exception>(() =>
        {
            AbstractFoo f1 = container.Resolve<AbstractFoo>();
        });
    }

    [Test]
    public void InstanceTest()
    {
        SimpleContainer container = new SimpleContainer();
        Foo foo1 = new Foo();
        container.RegisterInstance(foo1);
        Foo foo2 = container.Resolve<Foo>();
        Assert.AreEqual(foo1, foo2);
    }

    [Test]
    public void InterfaceInstanceTest()
    {
        SimpleContainer container = new SimpleContainer();
        AbstractFoo f1 = new Foo();
        container.RegisterInstance<AbstractFoo>(f1);
        AbstractFoo f2 = container.Resolve<AbstractFoo>();
        Assert.AreEqual(f1, f2);
    }

    [Test]
    public void OverrideInstanceTest()
    {
        SimpleContainer container = new SimpleContainer();
        AbstractFoo f1 = new Foo();
        AbstractFoo f2 = new Foo();
        container.RegisterInstance<AbstractFoo>(f1);
        container.RegisterInstance<AbstractFoo>(f2);
        AbstractFoo f3 = container.Resolve<AbstractFoo>();
        Assert.AreEqual(f2, f3);
        Assert.AreNotEqual(f1, f3);
    }

    [Test]
    public void DepencencyInjectionTest()
    {
        SimpleContainer container = new SimpleContainer();
        container.RegisterType<Foo>(false);
        container.RegisterType<Qux>(false);
        Qux q1 = container.Resolve<Qux>();
        Assert.IsNotNull(q1);
    }

    [Test]
    public void CycleTest()
    {
        SimpleContainer container = new SimpleContainer();
        container.RegisterType<CycleClass1>(false);
        container.RegisterType<CycleClass2>(false);
        var exception = Assert.Throws<Exception>(() =>
        {
            CycleClass1 f1 = container.Resolve<CycleClass1>();
        });
        Assert.AreEqual(exception.Message, "Cycle in dependencies detected.");
    }

    public class strTest
    {
        public String str;

        public strTest(String s)
        {
            str = s;
        }
    }
    
    [Test]
    public void StringTest()
    {
        SimpleContainer container = new SimpleContainer();
        container.RegisterInstance("Test");
        container.RegisterType<strTest>(false);
        strTest str = container.Resolve<strTest>();
        Assert.AreEqual(str.str, "Test");
    }

    [Test]
    public void NotInstanceExist()
    {
        SimpleContainer container = new SimpleContainer();
        
        var exception = Assert.Throws<Exception>(() =>
        {
            var f1 = container.Resolve<strTest>();
        });
        Assert.AreEqual(exception.Message, "Cannot resolve any constructor");
    }
    
    public class DependencyClass
    {
        [DependencyConstructor]
        public DependencyClass()
        {
        }

        public DependencyClass(Foo f)
        {
            throw new Exception("Shouldn't be called");
        }
    }

    [Test]
    public void DependencyAttributeTest()
    {
        SimpleContainer container = new SimpleContainer();
        DependencyClass d = container.Resolve<DependencyClass>();
    }

    class TwoConstructorTest1
    {
        private String str;

        public TwoConstructorTest1(int a, String b)
        {
            str = b;
        }

        public TwoConstructorTest1(int a, int b)
        {
            str = "abc";
        }
    }

    [Test]
    public void TwoSameLenghtConstructorTest()
    {
        SimpleContainer container = new SimpleContainer();
        container.RegisterInstance("TEST");

        var exception = Assert.Throws<Exception>(() =>
        {
            container.Resolve<TwoConstructorTest1>();
        });
        Assert.AreEqual(exception.Message, "Cannot resolve ambiguously.");
    }
    
    class TwoConstructorTest2
    {
        public String str;

        public TwoConstructorTest2(int a, String b)
        {
            str = b;
        }

        public TwoConstructorTest2(int a, int b)
        {
            str = "abc";
        }

        [DependencyConstructor]
        public TwoConstructorTest2(String a)
        {
            str = a;
        }
    }

    [Test]
    public void TwoConstructorDependency()
    {
        SimpleContainer container = new SimpleContainer();
        container.RegisterInstance("TEST");
        var test = container.Resolve<TwoConstructorTest2>();
        
        Assert.AreEqual(test.str, "TEST");
    }

    class DependencyConflict
    {
        [DependencyConstructor]
        public DependencyConflict(int a)
        {
            
        }

        [DependencyConstructor]
        public DependencyConflict(int a, int b)
        {
            
        }
        
    }

    [Test]
    public void DependencyConflictTest()
    {
        SimpleContainer container = new SimpleContainer();
        var exception = Assert.Throws<Exception>((() =>
        {
            container.Resolve<DependencyConflict>();
        }));
        Assert.AreEqual(exception.Message,"There can be only one dependency constructor.");
    }
    
    [Test]
    public void ExampleTest1()
    {
        SimpleContainer c = new SimpleContainer();
        A a = c.Resolve<A>();
        Assert.IsNotNull(a.b);
    }

    [Test]
    public void ExampleTest2()
    {
        SimpleContainer c = new SimpleContainer();
        Assert.Throws<Exception>(() =>
        {
            X x = c.Resolve<X>();
        });
    }

    [Test]
    public void ExampleTest2b()
    {
        SimpleContainer c = new SimpleContainer();
        c.RegisterInstance("ala ma kota");
        X x = c.Resolve<X>();
    }

    [Test]
    public void ExampleTest3()
    {
        SimpleContainer c = new SimpleContainer();
        c.RegisterType<IC, C>(false);
        A2 a = c.Resolve<A2>();
        Assert.IsNotNull(a.b);
        Assert.IsNotNull(a.c);
    }
    
    class DependencyMethodClass
    {
        public int a;
        public int b = 1;
        public int c = 0;
        public String constructor;
        
        public DependencyMethodClass(String constructor)
        {
            this.constructor = constructor;
        }

        [DependencyMethod]
        public void setA(int a)
        {
            this.a = a;
        }

        public void setB(int b)
        {
            this.b = b;
        }

        public void setC()
        {
            this.c = 2;
        }
    }

    [Test]
    public void DependencyMethodTest()
    {
        SimpleContainer container = new SimpleContainer();
        container.RegisterInstance("Constructor");
        container.RegisterInstance(12);
        var o = container.Resolve<DependencyMethodClass>();
        
        Assert.AreEqual(o.constructor, "Constructor");
        Assert.AreEqual(o.a, 12);
        Assert.AreEqual(o.b, 1);
        Assert.AreEqual(o.c, 0);
    }

    [Test]
    public void DependencyMethodClassFail()
    {
        SimpleContainer container = new SimpleContainer();
        container.RegisterInstance("Constructor");
        var exception = Assert.Throws<Exception>(() =>
        {
            var o = container.Resolve<DependencyMethodClass>();
            Assert.AreEqual(o.constructor, "Constructor");
        });
        Assert.AreEqual(exception.Message, "Cannot resolve any constructor");
        
    }

    public class DependencyPropertyClass {
        public DependencyPropertyClass(B b) {

        }
        [DependencyProperty]
        public C theC { get; set; }
    }

    [Test]
    public void DependencyPropertyTest() {
        SimpleContainer c = new SimpleContainer();
        DependencyPropertyClass test = c.Resolve<DependencyPropertyClass>();
        Assert.IsNotNull(test.theC);
    }

    [Test]
    public void BuildUpTest()
    {
        SimpleContainer container = new SimpleContainer();
        var o = new DependencyMethodClass("Constructor");
        container.RegisterInstance("dfsd");
        container.RegisterInstance(20);
        container.BuildUp(o);
        
        Assert.AreEqual(o.constructor, "Constructor");
        Assert.AreEqual(o.a, 20);

    }
    
    [Test]
    public void BuildUpTestFail()
    {
        SimpleContainer container = new SimpleContainer();
        container.RegisterInstance("Constructor");
        DependencyMethodClass o = null;
        var exception = Assert.Throws<Exception>(() =>
        {
            container.BuildUp(o);
        });
        Assert.AreEqual(exception.Message, "Argument cannot be null.");
        
    }
    
}