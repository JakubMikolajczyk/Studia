#include "csapp.h"

static pid_t spawn(void (*fn)(void)) {
    pid_t pid = Fork();
    if (pid == 0) {
        fn();
        printf("(%d) I'm done!\n", getpid());
        exit(EXIT_SUCCESS);
    }
    return pid;
}

static void do_nothing() {

}

static void grandchild(void) {
    printf("(%d) Waiting for signal!\n", getpid());
    /* TODO: Something is missing here! */
    // signal(SIGINT, do_nothing);
    pause();
    printf("(%d) Got the signal!\n", getpid());
}

static void child(void) {
    pid_t pid;
    /* TODO: Spawn a child! */
    pid = spawn(grandchild);
    printf("(%d) Grandchild (%d) spawned!\n", getpid(), pid);
}

/* Runs command "ps -o pid,ppid,pgrp,stat,cmd" using execve(2). */
static void ps(void) {
    /* TODO: Something is missing here! */
    pid_t pid = Fork();
    if(pid == 0) {
        char* argv[] = {"ps", "-o", "pid,ppid,pgid,stat,command", NULL};
        int t = execve("/bin/ps", argv, NULL);
        printf("(%d) Returned from execve() with %d", t);
        exit(EXIT_SUCCESS);
    }
    waitpid(pid, NULL, 0);
}

int main(void) {
    /* TODO: Make yourself a reaper. */
#ifdef LINUX
    Prctl(PR_SET_CHILD_SUBREAPER, 1);
#endif
    printf("(%d) I'm a reaper now!\n", getpid());

    pid_t pid, pgrp;
    int status;

    /* TODO: Start child and grandchild, then kill child!
     * Remember that you need to kill all subprocesses before quit. */
    pid = spawn(child);
    setpgid(0, getppid());
    ps();
    waitpid(pid, NULL, 0);;
    kill(-getpid(), SIGINT);
    setpgid(0, 0);
    waitpid(-1, &status, 0);
    printf("(%d) Killed grandchild's status is %d\n", getpid(), status);
    ps();
    return EXIT_SUCCESS;
}