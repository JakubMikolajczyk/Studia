// Jakub Mikolajczyk 324504
#include "traceroute.h"

int print(int ttl,int ireply, struct timespec *times, struct in_addr *reply);
void print_end(int ttl, struct timespec time, struct in_addr reply);
int calcaverage(struct timespec *times);

void traceroute(int sockfd, struct sockaddr_in recipient){


    for (int ttl = 1; ttl < 31; ttl++){
        struct timespec times[3];
        struct in_addr reply[3];
        int ireply = 0;

        send3packet(sockfd, recipient, ttl, times);
        int end = recive3packet(sockfd, ttl, &ireply, times, reply);


        print(ttl, ireply, times, reply);

        if (end == 1)
//            print_end(ttl, times[0], reply[0]);
            break;

        printf("\n");
    }

}

void print_end(int ttl, struct timespec time, struct in_addr reply){

    if(ttl < 10)    // wyrownanie
        printf(" ");
    char des[20];
    if(inet_ntop(AF_INET, &reply, des, sizeof(des)) == NULL){
        printf("inet_ntop error: %s", strerror(errno));
    }

    printf("%d. %s %ldms", ttl, des, time.tv_nsec/1000000);
}


int print(int ttl,int ireply, struct timespec *times, struct in_addr *reply){
    if(ttl < 10)    // wyrownanie
        printf(" ");
    printf("%d. ", ttl);

    if(ireply == 0){    // Brak odpowiedzi
        printf("*");
        return 1;
    }

    char ip0[20], ip1[20], ip2[20];
    if (inet_ntop(AF_INET, &(reply[0]), ip0, sizeof(ip0)) == NULL
    || inet_ntop(AF_INET, &(reply[1]), ip1, sizeof(ip1)) == NULL
    || inet_ntop(AF_INET, &(reply[2]), ip2, sizeof(ip2)) == NULL){
        printf("inet_ntop error: %s", strerror(errno));
    }

    printf("%s ", ip0);

    if(ireply > 1 && strcmp(ip0, ip1) != 0)
        printf("%s ", ip1);

    if(ireply > 2){
        if(strcmp(ip0, ip2) != 0 && strcmp(ip1, ip2) != 0)
            printf("%s ", ip2);

        printf("%dms", calcaverage(times)); // byly 3 odpowiedzi wiec mozna policzyc srednia
        return 1;
    }

    printf(" ???");

    return 0;
}

// Obliczanie sredniego czasu odpowiedzi
int calcaverage(struct timespec *times){

    int avg = (times[0].tv_nsec + times[1].tv_nsec + times[2].tv_nsec)/3000000;
    return avg;
}