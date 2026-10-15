namespace p5;

public class z5a
{
    public class Person {}
    public abstract class PersonRegistry
    {
        protected PersonNotifier _notifier;

        public PersonRegistry(PersonNotifier notifier)
        {
            this._notifier = notifier;
        }

        public abstract List<Person> GetPersons();

        public void Notify()
        {
            this._notifier.Notify(this.GetPersons());
        }
    }
    
    public abstract class PersonNotifier
    {
        public abstract void Notify(List<Person> persons);
    }

    public class XmlPersonRegistry : PersonRegistry
    {
        public XmlPersonRegistry(PersonNotifier notifier) : base(notifier)
        {
            
        }

        public override List<Person> GetPersons()
        {
            throw new NotImplementedException();
        }
    }

    public class SMSNotify : PersonNotifier
    {
        public override void Notify(List<Person> persons)
        {
            throw new NotImplementedException();
        }
    }
    
    // public void Main()
    // {
    //     PersonRegistry personRegistry = new XmlPersonRegistry(new SMSNotify());
    // }
}