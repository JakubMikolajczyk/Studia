package z5;
public class TriNode {


    enum CStatus {IDLE, FIRST, SECOND, THIRD, RESULT, ROOT;}

    CStatus cStatus;
    boolean lateLock;
    boolean waitLock;
    int waitingNodes, readyNodes;
    int firstValue;
    int[] secondVal = new int[2];
    int[] result = new int[2];
    TriNode parent;

    TriNode() {
        cStatus = CStatus.ROOT;
        lateLock = false;
        waitLock = false;
        waitingNodes = 0;
        readyNodes = 0;
    }

    TriNode(TriNode myParent) {
        parent = myParent;
        cStatus = CStatus.IDLE;
        lateLock = false;
        waitLock = false;
        waitingNodes = 0;
        readyNodes = 0;
    }

    synchronized boolean precombine() throws Exception {
        while (lateLock || waitingNodes >= 2) wait();

        switch (cStatus) {
            case IDLE:
                cStatus = CStatus.FIRST;
                return true;
            case FIRST:
                waitLock = true;
                waitingNodes = 1;
                cStatus = CStatus.SECOND;
                return false;
            case SECOND:
                waitingNodes = 2;
                cStatus = CStatus.THIRD;
                return false;
            case ROOT:
                return false;
            default:
                throw new IllegalStateException("unexpected Node state " + cStatus);
        }
    }

    synchronized int combine(int combined) throws InterruptedException {
        while (waitLock || readyNodes < waitingNodes) wait();

        firstValue = combined;
        lateLock = true;
        switch (cStatus) {
            case FIRST:
                return firstValue;
            case SECOND:
                return firstValue + secondVal[0];
            case THIRD:
                return firstValue + secondVal[0] + secondVal[1];
            default:
                throw new IllegalStateException("unexpected Node state " + cStatus);
        }
    }

    synchronized int op(int combined) throws InterruptedException, IllegalStateException {
        switch (cStatus) {
            case ROOT:
                int prior = result[0];
                result[0] += combined;
                return prior;
            case SECOND:
            case THIRD:
                secondVal[readyNodes] = combined;
                readyNodes++;
                if (readyNodes == waitingNodes) {
                    waitLock = false;
                    notifyAll();
                }
                while (cStatus != CStatus.RESULT) wait();
                readyNodes--;
                prior = result[readyNodes];
                if (readyNodes == 0) {
                    lateLock = false;
                    waitingNodes = 0;
                    notifyAll();
                    cStatus = CStatus.IDLE;
                }
                return prior;
            default:
                throw new IllegalStateException("unexpected Node state " + cStatus);
        }
    }

    synchronized void distribute(int prior) {
        switch (cStatus) {
            case FIRST:
                cStatus = CStatus.IDLE;
                lateLock = false;
                break;
            case SECOND:
                result[0] = prior + firstValue;
                cStatus = CStatus.RESULT;
                break;
            case THIRD:
                result[1] = prior + firstValue;
                result[0] = result[1] + secondVal[0];
                cStatus = CStatus.RESULT;
                break;
            default:
                throw new IllegalStateException("unexpected Node state " + cStatus);
        }
        notifyAll();
    }
}

