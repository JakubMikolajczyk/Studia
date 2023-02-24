#include "csapp.h"

static __unused void outc(char c) {
    Write(STDOUT_FILENO, &c, 1);
}

static __thread unsigned seed;

static sem_t tobacco;
static sem_t matches;
static sem_t paper;
static sem_t doneSmoking;


/* TODO: If you need any extra global variables, then define them here. */

static sem_t pusher_sem;

static sem_t tobacco_sem;
static sem_t paper_sem;
static sem_t match_sem;

int is_tobacco = 0;
int is_paper = 0;
int is_match = 0;

static void *agent(void *arg) {
    seed = pthread_self();

    while (true) {
        Sem_wait(&doneSmoking);

        int choice = rand_r(&seed) % 3;
        if (choice == 0) {
            Sem_post(&tobacco);
            Sem_post(&paper);
        } else if (choice == 1) {
            Sem_post(&tobacco);
            Sem_post(&matches);
        } else {
            Sem_post(&paper);
            Sem_post(&matches);
        }
    }

    return NULL;
}

/* TODO: If you need extra threads, then define their main procedures here. */

static void *pusherTobacco(void *arg){
    while (1){
        Sem_wait(&tobacco);
        Sem_wait(&pusher_sem);
        if(is_paper){
            is_paper -= 1;
            Sem_post(&match_sem);
        }
        else if (is_match){
            is_match -= 1;
            Sem_post(&paper_sem);
        }
        else {
            is_tobacco += 1;
        }
        Sem_wait(&pusher_sem);
    }
    return NULL;
}

static void *pusherPaper(void *arg){
    while (1){
        Sem_wait(&paper);
        Sem_wait(&pusher_sem);
        if(is_match){
            is_match -= 1;
            Sem_post(&tobacco_sem);
        }
        else if (is_tobacco){
            is_tobacco -= 1;
            Sem_post(&match_sem);
        }
        else {
            is_paper += 1;
        }
        Sem_wait(&pusher_sem);
    }

}


static void *pusherMatch(void *arg){
    while (1){
        Sem_wait(&matches);
        Sem_wait(&pusher_sem);
        if(is_paper){
            is_paper -= 1;
            Sem_post(&tobacco_sem);
        }
        else if (is_tobacco){
            is_tobacco -= 1;
            Sem_post(&paper_sem);
        }
        else {
            is_match += 1;
        }
        Sem_wait(&pusher_sem);
    }
    return NULL;
}

static void randsleep(void) {
    usleep(rand_r(&seed) % 1000 + 1000);
}

static void make_and_smoke(char smoker) {
    randsleep();
    Sem_post(&doneSmoking);
    outc(smoker);
    randsleep();
}

static void *smokerWithMatches(void *arg) {
    seed = pthread_self();

    while (true) {
        Sem_wait(&match_sem);
        /* TODO: wait for paper and tobacco */
        make_and_smoke('M');
    }

    return NULL;
}

static void *smokerWithTobacco(void *arg) {
    seed = pthread_self();

    while (true) {
        Sem_wait(&tobacco_sem);
        /* TODO: wait for paper and matches */
        make_and_smoke('T');
    }

    return NULL;
}

static void *smokerWithPaper(void *arg) {
    seed = pthread_self();

    while (true) {
        Sem_wait(&paper_sem);
        /* TODO: wait for tobacco and matches */
        make_and_smoke('P');
    }

    return NULL;
}

int main(void) {


    Sem_init(&tobacco, 0, 0);
    Sem_init(&matches, 0, 0);
    Sem_init(&paper, 0, 0);
    Sem_init(&doneSmoking, 0, 1);

    /* TODO: Initialize your global variables here. */
    Sem_init(&tobacco_sem, 0, 0);
    Sem_init(&match_sem, 0, 0);
    Sem_init(&paper_sem, 0, 0);
    Sem_init(&pusher_sem, 0, 1);

    pthread_t smokerPaperPusherThread, smokerMatchesPusherThread, smokerTobaccoPusherThread;
    Pthread_create(&smokerPaperPusherThread, NULL, pusherPaper, NULL);
    Pthread_create(&smokerMatchesPusherThread, NULL, pusherMatch, NULL);
    Pthread_create(&smokerTobaccoPusherThread, NULL, pusherTobacco, NULL);

    Pthread_join(smokerPaperPusherThread, NULL);
    Pthread_join(smokerMatchesPusherThread, NULL);
    Pthread_join(smokerMatchesPusherThread, NULL);

    // ****************************************
    pthread_t agentThread;
    Pthread_create(&agentThread, NULL, agent, NULL);

    pthread_t smokerPaperThread, smokerMatchesThread, smokerTobaccoThread;
    Pthread_create(&smokerPaperThread, NULL, smokerWithPaper, NULL);
    Pthread_create(&smokerMatchesThread, NULL, smokerWithMatches, NULL);
    Pthread_create(&smokerTobaccoThread, NULL, smokerWithTobacco, NULL);

    Pthread_join(agentThread, NULL);
    Pthread_join(smokerPaperThread, NULL);
    Pthread_join(smokerMatchesThread, NULL);
    Pthread_join(smokerTobaccoThread, NULL);


    return 0;
}
