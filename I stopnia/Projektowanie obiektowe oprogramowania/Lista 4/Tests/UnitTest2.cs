using NUnit.Framework;
using p4;

namespace Tests;

public class UnitTest2
{
    private z2.ShapeFactory _factory = new z2.ShapeFactory();

    [Test]
    public void SquareTest()
    {
        z2.IShape square = _factory.CreateShape("Square", 5);
        
        Assert.True(square is z2.Square);
    }

    [Test]
    public void NewWorkerTest()
    {
        _factory.RegisterWorker(new z2.RectangleFactoryWorker());
        z2.IShape rectangle = _factory.CreateShape("Rectangle", 2);
        
        Assert.True(rectangle is z2.Rectangle);
    }
}