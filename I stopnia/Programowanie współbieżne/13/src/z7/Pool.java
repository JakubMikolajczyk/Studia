package z7;

import z5.TriCombiningTree;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.locks.ReentrantLock;

public class Pool<T> {
    TriCombiningTree in, out;
    List<T> pool;
    ReentrantLock[] locks;

    Pool(int poolSize, int threadsNum){
        in = new TriCombiningTree(Math.ceilDiv(threadsNum, 3));
        out = new TriCombiningTree(Math.ceilDiv(threadsNum, 3));

        locks = new ReentrantLock[poolSize];
        pool = new ArrayList<>(poolSize);
        for (int i = 0; i < poolSize; i++) {
            pool.add(null);
            locks[i] = new ReentrantLock();
        }
    }

    void put(T item, int threadId) throws Exception {
        int i = in.getAndIncrement(threadId) % pool.size();
        while (true) {
            while (!locks[i].tryLock())
                ;
            try {
                if (pool.get(i) == null) {
                    pool.set(i, item);
                    System.out.println("THREAT ID: " + threadId + " PUT: " + item);
                    return;
                }
            } finally {
                locks[i].unlock();
            }
        }
    }

    T get (int threadId) throws Exception {
        int i = out.getAndIncrement(threadId) % pool.size();
        while (true) {
            while (!locks[i].tryLock())
                ;
            try {
                if (pool.get(i) != null) {
                    System.out.println("THREAT ID: " + threadId + " GET: " + pool.get(i));
                    return pool.set(i, null);
                }
            } finally {
                locks[i].unlock();
            }
        }
    }
}
