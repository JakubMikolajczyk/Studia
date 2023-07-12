#ifndef TRANSPORT_DATAGRAM_H
#define TRANSPORT_DATAGRAM_H

#include "config.h"
#include <string>
#include <netinet/ip.h>
#include <netinet/ip_icmp.h>
#include <arpa/inet.h>
#include <libc.h>
#include <iostream>

struct Datagram {

    int start = 0;
    int size = DATAGRAM_LEN;
    bool ready = false;
    timespec send_time;
    char data[DATAGRAM_LEN];

    void sendRequest(int sockfd, sockaddr_in serverAddr);

    void tryResend(int sockfd, sockaddr_in serverAddr);

    void saveToFile(int fd);
};


#endif //TRANSPORT_DATAGRAM_H
