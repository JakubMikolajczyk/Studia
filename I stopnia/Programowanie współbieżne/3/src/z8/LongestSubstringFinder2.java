package z8;

class Globals {
    public static int MIN_SIZE = 1;
}

class SubstringFinder implements Runnable {
    protected int arr[];
    protected int start;
    protected int end;
    public int first;
    public int first_len;
    public int last;
    public int last_len;
    public int max;
    public int max_len;

    public SubstringFinder(int arr[], int start, int end) {
        this.arr = arr;
        this.start = start;
        this.end = end;
    }

    private void combine(SubstringFinder f1, SubstringFinder f2) {
        int mid = 0, mid_len = 0;
        if (f1.last == f2.first) {
            mid = f1.last;
            mid_len = f1.last_len + f2.first_len;
        }
        this.first = f1.first;
        if (f1.first_len == f1.end - f1.start + 1
                && f1.first == f2.first) {
            this.first_len = f1.last_len + f2.first_len;
        } else {
            this.first_len = f1.first_len;
        }

        this.last = f2.last;
        if (f2.last_len == f2.end - f2.start + 1
                && f1.last == f2.last) {
            this.last_len = f1.last_len + f2.last_len;
        } else {
            this.last_len = f2.last_len;
        }

        this.max_len = Math.max(Math.max(Math.max(f1.max_len, f2.max_len),
                        Math.max(this.first_len, this.last_len)),
                mid_len);
        if (this.max_len == mid_len) {
            this.max = mid;
        }
        if (this.max_len == this.last_len) {
            this.max = this.last;
        }
        if (this.max_len == f2.max_len) {
            this.max = f2.max;
        }
        if (this.max_len == f1.max_len) {
            this.max = f1.max;
        }
        if (this.max_len == this.first_len) {
            this.max = this.first;
        }
    }

    private void linear_find() {
        first = arr[start];
        int temp = 1;
        max = first;
        max_len = temp;
        for (int i = start + 1; i <= end; i++) {
            if (arr[i] != arr[i - 1]) {
                if (arr[i - 1] == first) {
                    first_len = temp;
                }
                if (max_len < temp) {
                    max_len = temp;
                    max = arr[i - 1];
                }
                temp = 1;
            } else {
                temp += 1;
            }
        }
        last = arr[end];
        last_len = temp;
    }

    @Override
    public void run() {
        if (end - start > Globals.MIN_SIZE) {
            int m = (start + end) / 2;
            SubstringFinder f1 = new SubstringFinder(arr, start, m);
            SubstringFinder f2 = new SubstringFinder(arr, m + 1, end);
            Thread t1 = new Thread(f1);
            Thread t2 = new Thread(f2);
            t1.start();
            t2.start();
            try {
                t1.join();
                t2.join();
            } catch (InterruptedException e) {
                e.getStackTrace();
            }
            combine(f1, f2);
        } else {
            linear_find();
        }
    }
}

public class LongestSubstringFinder2 {
    public static void main(String[] args) {
//        int arr[] = {1,2,1,2,1,2,1,2,3,3,3};
//         int arr[] = {2,2,2,2,2,2,2,2,2};
//         int arr[] = {1,2,3,3,4,1};
        int arr[] = {3, 3, 1, 3, 4, 1};
        SubstringFinder f = new SubstringFinder(arr, 0, arr.length - 1);
        Thread t = new Thread(f);
        t.start();
        try {
            t.join();
        } catch (InterruptedException e) {
            e.getStackTrace();
        }

        System.out.printf("Found a substring of %d of length %d", f.max, f.max_len);
    }
}
