#ifndef TRANSPORT_TRANSPORT_H
#define TRANSPORT_TRANSPORT_H

#include "window.h"

struct Transport {
    Transport(int fd, int sockfd, sockaddr_in serverAddr, int fileSize);

    int packetsAll;
    int fd;
    int sockfd;
    sockaddr_in serverAddr;
    Window window;

    void download();

    void receiveDatagram();

    bool validateDatagram(sockaddr_in sender);

    void waitForDatagram();
};


#endif //TRANSPORT_TRANSPORT_H
