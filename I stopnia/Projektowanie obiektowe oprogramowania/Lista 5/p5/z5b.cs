namespace p5;

public class z5b
{
    public class Person {}
    
    public abstract class PersonNotify
    {
        protected PersonRegistry _personRegistry;

        public PersonNotify(PersonRegistry personRegistry)
        {
            this._personRegistry = personRegistry;
        }

        public abstract void Notify();
    }
    
    public abstract class PersonRegistry
    {
        public abstract List<Person> getPersons();
    }
    
    public class XMLPersonRegisty : PersonRegistry
    {
        public override List<Person> getPersons()
        {
            throw new NotImplementedException();
        }
    }
    
    public class SMSNotify : PersonNotify
    {
        public SMSNotify(PersonRegistry personRegistry) : base(personRegistry)
        {
            
        }

        public override void Notify()
        {
            throw new NotImplementedException();
        }
    }

    public void Main()
    {
        PersonNotify personNotify = new SMSNotify(new XMLPersonRegisty());
    }
}