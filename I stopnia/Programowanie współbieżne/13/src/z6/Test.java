package z6;

import java.util.Random;

public class Test implements Runnable{

    static final int THREATS = 100;
    CombiningTree tree = new CombiningTree(Math.ceilDiv(THREATS, 2));
    Thread[] threads = new Thread[THREATS];

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
                    int val = tree.getAndIncrement(id);
                    System.out.println("THREAT ID: " + id + " VAL: " + val);
                }
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }
    }
}
