using System;
using NUnit.Framework;
using p6;

namespace Tests;

public class z2Test
{
    private z2.Context ctx;

    [SetUp]
    public void SetUp()
    {
        ctx = new z2.Context();
        ctx.SetValue("x", true);
        ctx.SetValue("y", false);
    }

    [Test]
    public void ConstTestTrue()
    {
        z2.AbstractExpression expression = new z2.CONST(true);

        Assert.IsTrue(expression.Interpret(ctx));
    }

    [Test]
    public void ConstTestFalse()
    {
        z2.AbstractExpression expression = new z2.CONST(false);

        Assert.IsFalse(expression.Interpret(ctx));
    }

    [Test]
    public void VarTest1()
    {
        z2.AbstractExpression expression = new z2.Var("x");
        Assert.IsTrue(expression.Interpret(ctx));
    }

    [Test]
    public void VarTestNotSet()
    {
        z2.AbstractExpression expression = new z2.Var("z");
        Assert.Throws<ArgumentException>(() => { expression.Interpret(ctx); });
    }

    [Test]
    public void NotTestTrue()
    {
        z2.AbstractExpression expression = new z2.NOT(new z2.CONST(false));
        Assert.IsTrue(expression.Interpret(ctx));
    }

    [Test]
    public void NotTestFalse()
    {
        z2.AbstractExpression expression = new z2.NOT(new z2.CONST(true));
        Assert.IsFalse(expression.Interpret(ctx));
    }

    [Test]
    public void OrTestTrue1()
    {
        z2.AbstractExpression expression = new z2.OR(new z2.CONST(true), new z2.CONST(false));
        Assert.IsTrue(expression.Interpret(ctx));
    }

    [Test]
    public void OrTestTrue2()
    {
        z2.AbstractExpression expression = new z2.OR(new z2.CONST(true), new z2.CONST(true));
        Assert.IsTrue(expression.Interpret(ctx));
    }

    [Test]
    public void OrTestTrue3()
    {
        z2.AbstractExpression expression = new z2.OR(new z2.CONST(false), new z2.CONST(true));
        Assert.IsTrue(expression.Interpret(ctx));
    }

    [Test]
    public void OrTestFalse()
    {
        z2.AbstractExpression expression = new z2.OR(new z2.CONST(false), new z2.CONST(false));
        Assert.IsFalse(expression.Interpret(ctx));
    }

    [Test]
    public void AndTestTrue()
    {
        z2.AbstractExpression expression = new z2.AND(new z2.CONST(true), new z2.CONST(true));
        Assert.IsTrue(expression.Interpret(ctx));
    }

    [Test]
    public void AndTestFalse1()
    {
        z2.AbstractExpression expression = new z2.AND(new z2.CONST(false), new z2.CONST(true));
        Assert.IsFalse(expression.Interpret(ctx));
    }

    [Test]
    public void AndTestFalse2()
    {
        z2.AbstractExpression expression = new z2.AND(new z2.CONST(true), new z2.CONST(false));
        Assert.IsFalse(expression.Interpret(ctx));
    }

    [Test]
    public void AndTestFalse3()
    {
        z2.AbstractExpression expression = new z2.AND(new z2.CONST(false), new z2.CONST(false));
        Assert.IsFalse(expression.Interpret(ctx));
    }

    [Test]
    public void MultipleOperationTest1()
    {
        z2.AbstractExpression expression =
            new z2.AND(
                new z2.Var("x"),
                new z2.OR(
                    new z2.OR(
                        new z2.Var("y"),
                        new z2.CONST(false)),
                    new z2.CONST(true)));
        Assert.IsTrue(expression.Interpret(ctx));
    }

    [Test]
    public void MultipleOperationTest2()
    {
        z2.AbstractExpression expression =
            new z2.OR(
                new z2.NOT(new z2.CONST(true)),
                new z2.AND(
                    new z2.Var("y"),
                    new z2.NOT(new z2.Var("x")))
            );
        Assert.IsFalse(expression.Interpret(ctx));
    }
}