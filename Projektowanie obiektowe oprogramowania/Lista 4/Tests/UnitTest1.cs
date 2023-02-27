using System.Threading;
using NUnit.Framework;
using p4;

namespace Tests;

public class Tests
{

    [Test]
    public void Singleton()
    {
        z1.Singleton1 t1 = z1.Singleton1.Instance();
        z1.Singleton1 t2 = z1.Singleton1.Instance();

        Assert.AreEqual(t1, t2);
    }

    [Test]
    public void SingletonThread1()
    {
        object t1 = null, t2 = null;
        
        Thread a = new Thread(() =>
        {
             t1 = z1.SingletonThread.Instance();
             t2 = z1.SingletonThread.Instance();
            
        });
        a.Start();
        a.Join();
        
        Assert.AreEqual(t1, t2);
    }
    
    [Test]
    public void SingletonThread2()
    {
        object t1 = null, t2 = null;
        
        Thread a = new Thread(() =>
        {
             t1 = z1.SingletonThread.Instance();
        });
        
        Thread b = new Thread(() =>
        {
             t2 = z1.SingletonThread.Instance();
        });
        a.Start();
        b.Start();
        a.Join();
        b.Join();
        
        Assert.AreNotEqual(t1, t2);
    }
    
    [Test]
    public void SingletonTime1()
    {
        z1.SingletonTime t1 = z1.SingletonTime.Instance();
        Thread.Sleep(5500);
        z1.SingletonTime t2 = z1.SingletonTime.Instance();
        
        Assert.AreNotEqual(t1, t2);
    }
    
    [Test]
    public void SingletonTime2()
    {
        z1.SingletonTime t1 = z1.SingletonTime.Instance();
        z1.SingletonTime t2 = z1.SingletonTime.Instance();
        
        Assert.AreEqual(t1, t2);
    }
}