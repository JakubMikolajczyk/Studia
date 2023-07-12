// Jakub Mikolajczyk 324504
#include "traceroute.h"

// Wczytywanie i przetwarzanie inputu + stworzenie gniazda
int main(int argc, char *argv[]) {

    if (argc != 2){
        printf("Wrong input");
        exit(EXIT_FAILURE);
    }

    struct sockaddr_in recipient;
    bzero(&recipient, sizeof(struct sockaddr_in));
    recipient.sin_family = AF_INET;
    int ret = inet_pton(AF_INET, argv[1], &recipient.sin_addr);
    if(ret == 0){
        printf("Wrong input ip: %s", strerror(errno));
        exit(EXIT_FAILURE);
    }

    if(ret < -1){
        printf("inet_pton error: %s", strerror(errno));
        exit(EXIT_FAILURE);
    }

    int sockfd = socket(AF_INET, SOCK_RAW, IPPROTO_ICMP);

    if (sockfd < 0) {
        fprintf(stderr, "socket error: %s\n", strerror(errno));
        exit(EXIT_FAILURE);
    }

    traceroute(sockfd, recipient);

    return 0;
}


