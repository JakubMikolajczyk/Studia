package z6;
import java.util.Arrays;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

abstract class Task{

    protected BlockingQueue<Task> queue;
    abstract public void execute() throws InterruptedException;
}

class TerminateTask extends Task{

    public TerminateTask(BlockingQueue<Task> queue) {
        this.queue = queue;
    }

    @Override
    public void execute() throws InterruptedException {
        queue.put(this);
        Thread.currentThread().interrupt();
    }
}

class MergeTask extends Task{

    private final int l, m, r;
    private final int[] arr, buf;
    private final MergeTask parent;
    private int childCompleted;

    public MergeTask(int[] arr, int[] buf, BlockingQueue<Task> queue, int l, int m, int r, MergeTask parent){
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

    private void completeParent() throws InterruptedException {
        if (parent == null){
            queue.put(new TerminateTask(queue));
        }
        else {
            parent.completeChild();
        }
    }

    @Override
    public void execute() throws InterruptedException {
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
            queue.put(this);
        }
    }
}

class SplitTask extends Task{

    private final int l, r;
    private final int[] arr, buf;
    private final MergeTask parent;

    public SplitTask(int[] arr, int[] buf, BlockingQueue<Task> queue, int l, int r, MergeTask parent) {
        this.arr = arr;
        this.buf = buf;
        this.queue = queue;
        this.l = l;
        this.r = r;
        this.parent = parent;
    }

    @Override
    public void execute() throws InterruptedException {
        if (l < r){
            int m = (l + r)/2;
            MergeTask mergeTask = new MergeTask(arr, buf, queue, l, m, r, parent);
            queue.put(new SplitTask(arr, buf, queue, l, m, mergeTask));
            queue.put(new SplitTask(arr, buf, queue, m + 1, r, mergeTask));
            queue.put(mergeTask);
        }
        else{
            if(parent == null){
                queue.put(new TerminateTask(queue));
            }
            else {
                parent.completeChild();
            }
        }
    }
}

class Worker implements Runnable{

    private final BlockingQueue<Task> queue;

    public Worker(BlockingQueue<Task> queue) {
        this.queue = queue;
    }

    @Override
    public void run() {
        while (!Thread.currentThread().isInterrupted()){
            Task task = null;
            try {
                task = queue.take();
                task.execute();
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }
    }
}

class PoolManager{

    static int THREATS = 5;

    public PoolManager(int[] arr) throws InterruptedException {
        int [] buf = new int[arr.length];
        BlockingQueue<Task> queue = new LinkedBlockingQueue<Task>();

        queue.put(new SplitTask(arr, buf, queue, 0, arr.length - 1, null));

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

public class z6 {

    public static void main(String[] args) throws InterruptedException {
        int []arr = {4,5,2,6,1,654,675,21,3,54,73,21,654,865,4,36,2,8,0};
        new PoolManager(arr);

        System.out.println(Arrays.toString(arr));
    }
}
