using System;
using System.Reflection;

public class DependencyConstructor : Attribute
{

}

public class DependencyMethod : Attribute
{

}

public class DependencyProperty : Attribute
{

}

public class SimpleContainer
{
    Dictionary<Type, Boolean> types = new Dictionary<Type, Boolean>();
    Dictionary<Type, Type> implementation = new Dictionary<Type, Type>();
    Dictionary<Type, object> singletons = new Dictionary<Type, object>();
    Dictionary<Type, object> instance = new Dictionary<Type, object>();
    HashSet<Type> cycleDetector = new HashSet<Type>();

    public void RegisterType<T>(bool Singleton) where T : class
    {
        types[typeof(T)] = Singleton;
        implementation[typeof(T)] = typeof(T);
    }
    public void RegisterType<From, To>(bool Singleton) where To : From
    {
        types[typeof(From)] = Singleton;
        implementation[typeof(From)] = typeof(To);
    }
    public void RegisterInstance<T>(T newInstance)
    {
        instance[typeof(T)] = newInstance;
    }
    public T Resolve<T>()
    {
        cycleDetector.Clear();
        var result = (T)Resolve(typeof(T));
        CallDependencyMethods(result);
        InitDependencyProperties(result);
        return result;
    }
    public void BuildUp<T>(T instance)
    {
        if (instance == null) {
            throw new Exception("Argument cannot be null.");
        }
        CallDependencyMethods(instance);
        InitDependencyProperties(instance);
    }

    private object Resolve(Type type)
    {
        if (instance.ContainsKey(type))
        {
            return instance[type];
        }

        if (!implementation.ContainsKey(type) && (type.IsInterface || type.IsAbstract))
        {
            throw new Exception("Interface was not registered");
        }

        bool isSingleton = false;
        if (types.TryGetValue(type, out isSingleton) && isSingleton)
        {
            object result;
            if (singletons.TryGetValue(type, out result))
            {
                return result;
            }
            else
            {
                result = Constructor(type);
                singletons[type] = result;
                return result;
            }
        }
        else
        {
            if (types.ContainsKey(type))
            {
                return Constructor(implementation[type]);
            }
            else
            {
                return Constructor(type);
            }
        }
    }

    private Object Constructor(Type type)
    {
        if (cycleDetector.Contains(type))
        {
            throw new Exception("Cycle in dependencies detected.");
        }
        cycleDetector.Add(type);


        ConstructorInfo[] constructors = type.GetConstructors();
        if (constructors.Length == 0)
        {
            throw new Exception("Cannot resolve any constructor");
        }
        ConstructorInfo maxParamConstructor = constructors.First();
        ConstructorInfo secondMaxParamConstructor = constructors.First();
        ConstructorInfo adnotationConstructor = null;
        foreach (ConstructorInfo c in constructors)
        {
            ParameterInfo[] currentParameters = c.GetParameters();

            if (currentParameters.Length >= maxParamConstructor.GetParameters().Length)
            {
                secondMaxParamConstructor = maxParamConstructor;
                maxParamConstructor = c;
            }
            if (c.GetCustomAttribute(typeof(DependencyConstructor)) != null)
            {
                if (adnotationConstructor != null)
                {
                    throw new Exception("There can be only one dependency constructor.");
                }
                adnotationConstructor = c;
            }
        }
        if (maxParamConstructor.GetParameters().Length == secondMaxParamConstructor.GetParameters().Length && maxParamConstructor != constructors.First() && adnotationConstructor == null)
        {
            throw new Exception("Cannot resolve ambiguously.");
        }

        ConstructorInfo selectedConstructor;
        if (adnotationConstructor != null)
        {
            selectedConstructor = adnotationConstructor;
        }
        else
        {
            selectedConstructor = maxParamConstructor;
        }


        object[] parameters = selectedConstructor.GetParameters().Select(x => Resolve(x.ParameterType)).ToArray();
        return selectedConstructor.Invoke(parameters);
    }

    private void CallDependencyMethods(Object o)
    {
        Type type = o.GetType();
        var allMethods = type.GetMethods();
        var methods = from method in allMethods
                      where method.GetCustomAttribute(typeof(DependencyMethod)) != null
                      && method.ReturnType == typeof(void)
                      && method.GetParameters().Length > 0
                      select method;
        foreach (var method in methods)
        {
            object[] parameters = method.GetParameters().Select(x => Resolve(x.ParameterType)).ToArray();
            method.Invoke(o, parameters);
        }
    }

    private void InitDependencyProperties(Object o)
    {
        Type type = o.GetType();
        var allProperties = type.GetProperties();
        var properties = from property in allProperties
                         where property.GetCustomAttribute(typeof(DependencyProperty)) != null
                         && property.GetAccessors().Any(acc => acc.IsPublic)
                         select property;
        foreach(var property in properties) {
            property.SetValue(o, Resolve(property.PropertyType));
        }
    }
}
