#include <sys/select.h>
#include "transport.h"

Transport::Transport(int fd, int sockfd, sockaddr_in serverAddr, int fileSize) :
        fd(fd),
        sockfd(sockfd),
        serverAddr(serverAddr),
        packetsAll(fileSize / DATAGRAM_LEN + (fileSize % DATAGRAM_LEN != 0)),
        window(fd, sockfd, serverAddr,
               fileSize / DATAGRAM_LEN + (fileSize % DATAGRAM_LEN != 0),
               fileSize % DATAGRAM_LEN){}

void Transport::download() {

    int prevCounter = 0;
    while (!this->window.isEnd()) {
        window.tryResend();
        waitForDatagram();
        window.trySave();
        if(prevCounter != this->window.packetReceive) {
            printf("Progress: %f/100\n", (float) this->window.packetReceive / this->packetsAll);
            prevCounter = this->window.packetReceive;
        }
    }

}

void Transport::waitForDatagram() {

    timeval test;
    test.tv_sec = 0;
    test.tv_usec = 0;
    fd_set descriptors;
    while (!this->window.isEnd()) {
        FD_ZERO(&descriptors);
        FD_SET(this->sockfd, &descriptors);
        int ready = select(this->sockfd + 1, &descriptors, NULL, NULL, &test);

        if (ready < 0)
            throw std::runtime_error("select error");

        if (ready != 0)
            receiveDatagram();

        if (ready == 0) {
            return;
        }
    }

}

void Transport::receiveDatagram() {

    sockaddr_in sender;
    socklen_t socklen = sizeof(sender);

    char buf[IP_MAXPACKET];
    int length = recvfrom(this->sockfd, buf, IP_MAXPACKET, MSG_DONTWAIT, (struct sockaddr *) &sender, &socklen);
    if (length < 0) {
        throw std::runtime_error("recvfrom error");
    }

    if (!validateDatagram(sender))
        return;

    int start;
    int size;
    int items = sscanf(buf, "DATA %d %d\n", &start, &size);
    if (items != 2)
        throw std::runtime_error("sscanf error");

    if(start < this->window.range)
        return;

    int offset = DATAGRAM_OFFSET + std::to_string(start).length() + std::to_string(size).length();
    this->window.receiveDatagram(start, size, buf + offset);
}

bool Transport::validateDatagram(sockaddr_in sender) {
    return this->serverAddr.sin_addr.s_addr == sender.sin_addr.s_addr
           && this->serverAddr.sin_port == sender.sin_port;
}