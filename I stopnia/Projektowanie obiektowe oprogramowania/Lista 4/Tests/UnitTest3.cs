using System;
using System.Numerics;
using NUnit.Framework;
using p4;

namespace Tests;


public class UnitTest3
{
    [Test]
    public void InvalidCapacity1()
    {
        Assert.Throws<ArgumentException>((() =>
        {
            z3.Airport airport = new z3.Airport(0);
        }));
    }
    
    [Test]
    public void ValidCapacity()
    {
        z3.Airport airport = new z3.Airport(1);
        Assert.IsNotNull(airport);
    }
    
    [Test]
    public void ValidAcquire()
    {
        z3.Airport airport = new z3.Airport(1);
        z3.Plane plane = airport.AcquireReusable();
        
        Assert.IsNotNull(plane);
    }
    
    [Test]
    public void CapacityDepleted()
    {
        z3.Airport airport = new z3.Airport(1);
        z3.Plane plane = airport.AcquireReusable();
        
        Assert.Throws<ArgumentException>((() =>
        {
           z3.Plane plane2 = airport.AcquireReusable();
        }));
    }
    
    [Test]
    public void ReusedPlane()
    {
        z3.Airport airport = new z3.Airport(1);
        z3.Plane plane = airport.AcquireReusable();
        airport.ReleaseReusable(plane);
        z3.Plane plane2 = airport.AcquireReusable();
        
        Assert.AreEqual(plane,plane2);
    }
    
    [Test]
    public void RealeseInvalidPlane()
    {
        z3.Airport airport = new z3.Airport(1);
        z3.Plane plane = airport.AcquireReusable();
        
        
        Assert.Throws<ArgumentException>((() =>
        {
            z3.Plane invalidPlane = new z3.Plane();
            airport.ReleaseReusable(invalidPlane);
        }));
    }
}