//
// Created by Jakub Mikołajczyk on 25/04/2023.
//

#ifndef TRANSPORT_WINDOW_H
#define TRANSPORT_WINDOW_H

#include "datagram.h"


struct Window {

    int begin = 0;
    int end;
    int fileSize;
    int fd;
    int sockfd;
    int packetReceive;
    int range = 0;
    sockaddr_in serverAddr;

    Datagram datagrams[WINDOW_SIZE];

    Window(int fd, int sockfd, sockaddr_in serverAddr, int packets, int lastPacket);
    static int prev(int val);

    static int next(int val);

    Datagram *findDatagram(int begin);

    void receiveDatagram(int start, int size, char *buf);

    void trySave();

    bool canSaveFirst();

    Datagram* getFirstDatagram();

    Datagram* getLastDatagram();

    void tryResend();

    bool isEnd();
};


#endif //TRANSPORT_WINDOW_H
