#ifndef TRANSPORT_PACKET_H
#define TRANSPORT_PACKET_H

#include "config.h"
#include <string>
#include <netinet/ip.h>
#include <netinet/ip_icmp.h>
#include <arpa/inet.h>
#include <libc.h>
#include <iostream>

struct Packet {

    int start;
    int size;
    bool ready;
    char data[DATAGRAM_LEN];

    Packet(int start, int size);

    void sendRequest(int sockfd, sockaddr_in serverAddr);

    void saveToFile(int fd);

    void saveToData(char *buf);
};


#endif //TRANSPORT_PACKET_H
