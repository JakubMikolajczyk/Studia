#ifndef TRANSPORTV2_TRANSPORT_H
#define TRANSPORTV2_TRANSPORT_H

#include <deque>
#include "packet.h"

struct Transport {

    int fd;
    int sockfd;
    sockaddr_in serverAddr;
    int fileSize;

    int savedPacket;
    int packetAll;
    int packetReceived;
    std::deque<Packet> window;

    Transport(int fd, int sockfd, sockaddr_in serverAddr, int fileSize);

    void download();

    void waitForPacket();

    void receivePacket();

    bool validatePacket(sockaddr_in sender);

    void save();

    int howManyPacket(int fileSize);

    void resendPacket();
};


#endif //TRANSPORTV2_TRANSPORT_H
