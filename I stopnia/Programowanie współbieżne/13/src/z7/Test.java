package z7;

import java.util.Random;

public class Test implements Runnable{

    static final int THREATS = 14;
    Thread[] threads = new Thread[THREATS];
    Pool<Integer> pool = new Pool<Integer>(20, THREATS);

    @Override
    public void run() {
        for (int i = 0; i < THREATS; i++) {
            threads[i] = new MyThread(i);
        }

        for (int i = 0; i < THREATS; i++) {
            threads[i].start();
        }

        for (int i = 0; i < THREATS; i++) {
            try {
                threads[i].join();
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }
    }


    class MyThread extends Thread{
        int id;

        MyThread(int id){
            this.id = id;
        }

        public void run(){
            try {
                for (int i = 0; i < 2; i++) {
                    sleep(new Random().nextInt(100));
                    if (id % 2 == 0){
                        pool.put(id, id);
                    }
                    else {
                        pool.get(id);
                    }
                }
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }
    }
}
