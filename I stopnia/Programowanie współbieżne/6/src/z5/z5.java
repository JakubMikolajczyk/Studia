package z5;
import java.util.Arrays;
import java.util.Queue;
import java.util.concurrent.ConcurrentLinkedQueue;

abstract class Task{

    Queue<Task> queue;
    abstract public void execute();
}

class TerminateTask extends Task{

    public TerminateTask(Queue<Task> queue) {
        this.queue = queue;
    }

    @Override
    public void execute() {
        queue.offer(this);
        Thread.currentThread().interrupt();
    }
}

class MergeTask extends Task{

    int l, m, r;
    int[] arr, buf;
    MergeTask parent;
    int childCompleted;

    public MergeTask(int[] arr, int[] buf, Queue<Task> queue, int l, int m, int r, MergeTask parent){
        this.arr = arr;
        this.buf = buf;
        this.queue = queue;
        this.childCompleted = 0;
        this.l = l;
        this.m = m;
        this.r = r;
        this.parent = parent;
    }

    private boolean isReady(){
        return childCompleted == 2;
    }

    public synchronized void completeChild(){
        childCompleted++;
    }

    private void completeParent(){
        if (parent == null){
            queue.offer(new TerminateTask(queue));
        }
        else {
            parent.completeChild();
        }
    }

    @Override
    public void execute(){
        if (isReady()){
            System.arraycopy(arr, l, buf, l, r - l + 1);

            int leftIndex = l;
            int leftEnd = m + 1;

            int rightIndex = m + 1;
            int rightEnd = r + 1;

            int arrIndex = l;
            while (leftIndex < leftEnd && rightIndex < rightEnd){
                if (buf[leftIndex] <= buf[rightIndex]){
                    arr[arrIndex] = buf[leftIndex];
                    leftIndex++;
                }
                else {
                    arr[arrIndex] = buf[rightIndex];
                    rightIndex++;
                }
                arrIndex++;
            }
            System.arraycopy(buf, leftIndex, arr, arrIndex, leftEnd - leftIndex);
            System.arraycopy(buf, rightIndex, arr, arrIndex, rightEnd - rightIndex);

            completeParent();
        }
        else {
            queue.offer(this);
        }
    }
}

class SplitTask extends Task{

    int l, r;
    int[] arr, buf;
    MergeTask parent;

    public SplitTask(int[] arr, int[] buf, Queue<Task> queue, int l, int r, MergeTask parent) {
        this.arr = arr;
        this.buf = buf;
        this.queue = queue;
        this.l = l;
        this.r = r;
        this.parent = parent;
    }

    @Override
    public void execute() {
        if (l < r){
            int m = (l + r)/2;
            MergeTask mergeTask = new MergeTask(arr, buf, queue, l, m, r, parent);
            queue.offer(new SplitTask(arr, buf, queue, l, m, mergeTask));
            queue.offer(new SplitTask(arr, buf, queue, m + 1, r, mergeTask));
            queue.offer(mergeTask);
        }
        else{
            parent.completeChild();
        }
    }
}

class Worker implements Runnable{

    Queue<Task> queue;

    public Worker(Queue<Task> queue) {
        this.queue = queue;
    }

    @Override
    public void run() {
        while (!Thread.currentThread().isInterrupted()){
            Task task = queue.poll();
            if (task != null){
                task.execute();
            }
        }
    }
}

class PoolManager{

    static int THREATS = 5;
    int []arr, buf;
    Queue<Task> queue;

    public PoolManager(int[] arr) {
        this.arr = arr;
        this.buf = new int[arr.length];
        this.queue = new ConcurrentLinkedQueue<Task>();

        queue.offer(new SplitTask(arr, buf, queue, 0, arr.length - 1, null));

        for (int i = 0; i < THREATS; i++){
            Thread thread = new  Thread(new Worker(queue));
            thread.start();
            try {
                thread.join();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}

public class z5 {

    public static void main(String[] args){
        int []arr = {4,5};
        new PoolManager(arr);

        System.out.println(Arrays.toString(arr));
    }
}
