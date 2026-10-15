package z6;

import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

public class ExchangeNode {

    enum CStatus {IDLE, FIRST, SECOND, ROOT;}

    CStatus cStatus;
    boolean lock;
    int firstValue;
    LockFreeExchanger<Integer> exchanger;
    ExchangeNode parent;

    ExchangeNode() {
        cStatus = CStatus.ROOT;
        lock = false;
    }

    ExchangeNode(ExchangeNode myParent) {
        parent = myParent;
        cStatus = CStatus.IDLE;
        lock = false;
        exchanger = new LockFreeExchanger<Integer>();
    }

    synchronized boolean precombine() throws Exception {
        while (lock) wait();

        switch (cStatus) {
            case IDLE:
                cStatus = CStatus.FIRST;
                return true;
            case FIRST:
                lock = true;
                cStatus = CStatus.SECOND;
                return false;
            case ROOT:
                return false;
            default:
                throw new IllegalStateException("unexpected Node state " + cStatus);
        }
    }

    synchronized int combine(int combined) throws InterruptedException, TimeoutException {
        lock = true;
        firstValue = combined;
        switch (cStatus) {
            case FIRST:
                return firstValue;
            case SECOND:
                return firstValue + exchanger.exchange(0, 10, TimeUnit.SECONDS);
            default:
                throw new IllegalStateException("unexpected Node state " + cStatus);
        }
    }

    synchronized int op(int combined) throws InterruptedException, IllegalStateException, TimeoutException {
        switch (cStatus) {
            case ROOT:
                int prior = firstValue;
                firstValue += combined;
                return prior;
            case SECOND:
                exchanger.exchange(combined, 10, TimeUnit.SECONDS);
                int result = exchanger.exchange(0, 10, TimeUnit.SECONDS);
                cStatus = CStatus.IDLE;
                lock = false;
                return result;
            default:
                throw new IllegalStateException("unexpected Node state " + cStatus);
        }
    }

    synchronized void distribute(int prior) throws InterruptedException, TimeoutException {
        switch (cStatus) {
            case FIRST:
                cStatus = CStatus.IDLE;
                lock = false;
                break;
            case SECOND:
                exchanger.exchange(firstValue + prior, 10, TimeUnit.SECONDS);
                break;
            default:
                throw new IllegalStateException("unexpected Node state " + cStatus);
        }
        notifyAll();
    }
}
