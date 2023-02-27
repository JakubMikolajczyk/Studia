namespace p4;

public class z3 {

    public class Plane
    {
        
    }

    public class Airport
    {
        private List<Plane> ready = new List<Plane>();
        private List<Plane> realesed = new List<Plane>();
        private int _capacity;

        public Airport(int capacity)
        {
            if (capacity <= 0)
            {
                throw new ArgumentException();
            }
            this._capacity = capacity;
        }

        public Plane AcquireReusable()
        {
            if (realesed.Count == _capacity)
            {
                throw new ArgumentException();
            }

            if (ready.Count == 0)
            {
                Plane newPlane = new Plane();
                ready.Add(newPlane);
            }

            Plane plane = ready[0];
            ready.Remove(plane);
            realesed.Add(plane);

            return plane;
        }

        public void ReleaseReusable(Plane reusable)
        {
            if (!realesed.Contains(reusable))
            {
                throw new ArgumentException();
            }

            realesed.Remove(reusable);
            ready.Add(reusable);
        }
    }
}