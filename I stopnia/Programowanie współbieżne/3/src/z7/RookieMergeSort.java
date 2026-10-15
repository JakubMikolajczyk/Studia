package z7;

class MergeSort implements Runnable {
    protected int[] arr;
    protected int[] help_arr;

    protected int l, r;

    public static final int MAX_THREAT = 10;
    protected static int THREAT = 1;
    protected static final Object lock = new Object();
    MergeSort(int[] arr, int[] help_arr, int l, int r) {
        this.arr = arr;
        this.help_arr = help_arr;
        this.l = l;
        this.r = r;
    }

    private void merge(int l, int m, int r) {

        System.arraycopy(arr, l, help_arr, l, r - l + 1);

        int leftIndex = l;
        int leftEnd = m + 1;

        int rightIndex = m + 1;
        int rightEnd = r + 1;

        int arrIndex = l;
        while (leftIndex < leftEnd && rightIndex < rightEnd){
            if (help_arr[leftIndex] <= help_arr[rightIndex]){
                arr[arrIndex] = help_arr[leftIndex];
                leftIndex++;
            }
            else {
                arr[arrIndex] = help_arr[rightIndex];
                rightIndex++;
            }
            arrIndex++;
        }

        System.arraycopy(help_arr, leftIndex, arr, arrIndex, leftEnd - leftIndex);
        System.arraycopy(help_arr, rightIndex, arr, arrIndex, rightEnd - rightIndex);
    }

    public void sort(int l, int r) {
        if (l < r) {
            int m = (l + r) / 2;
            sort(l, m);
            sort(m + 1, r);
            merge(l, m, r);
        }
    }

    public void sortSmall(int l, int r){
        for (int i = l; i < r + 1; i++){
            int minIndex = i;
            for (int j = i + 1; j < r + 1; j++)
                if(arr[j] < arr[minIndex])
                    minIndex = j;
            swap(minIndex, i);
        }
    }

    private void swap(int a, int b){
        int temp = arr[a];
        arr[a] = arr[b];
        arr[b] = temp;
    }
    @Override
    public void run() {
        if (this.l < this.r) {
            if (r - l + 1 < 5){
                sortSmall(l, r);
            }
            else
            {
                int m = (this.l + this.r) / 2;
                MergeSort left = new MergeSort(arr, help_arr, this.l, m);
                MergeSort right = new MergeSort(arr, help_arr, m + 1, this.r);
                Thread t1 = new Thread(left);
                t1.start();
                right.run();
                try {
                    t1.join();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                this.merge(this.l, m, this.r);
            }
        }
    }
}


public class RookieMergeSort {

    public static void main(String[] args) {
        int arr[] = {4, 3, 2, 1, 10, 15, 2, 14, 4, 8, 9};
        MergeSort w = new MergeSort(arr, new int[arr.length],0, arr.length - 1);

        Thread t = new Thread(w);

        t.start();
        try {
            t.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        for (int i = 0; i < arr.length; i++)
            System.out.printf("%d ", arr[i]);

    }
}