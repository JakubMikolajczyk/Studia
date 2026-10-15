#include "transport.h"

Transport::Transport(int fd, int sockfd, sockaddr_in serverAddr, int fileSize) :
        fd(fd),
        sockfd(sockfd),
        serverAddr(serverAddr),
        fileSize(fileSize),
        savedPacket(0),
        packetReceived(0){

    this->packetAll = howManyPacket(fileSize);

    int initWindow = std::min(WINDOW_SIZE, this->packetAll - 1);

    int i;
    for (i = 0; i < initWindow; i++)
        this->window.push_back(Packet(i * DATAGRAM_LEN, DATAGRAM_LEN));

    if(initWindow != WINDOW_SIZE)
        this->window.push_back(Packet(i * DATAGRAM_LEN,
                               fileSize % DATAGRAM_LEN == 0 ? DATAGRAM_LEN : fileSize % DATAGRAM_LEN));

}

int Transport::howManyPacket(int fileSize){
    if(fileSize < DATAGRAM_LEN)
        return 1;
    else if (fileSize % DATAGRAM_LEN == 0)
        return fileSize / DATAGRAM_LEN;
    else return fileSize / DATAGRAM_LEN + 1;
}

void Transport::download() {

    int prevProgress = 0;
    while (!this->window.empty()){
        resendPacket();
        waitForPacket();
        save();
        if(prevProgress != this->packetReceived){
            prevProgress = this->packetReceived;
            printf("Progress %f/100\n", (float) 100 * this->packetReceived/ this->packetAll);
        }
    }

}

void Transport::waitForPacket() {

    timeval test;
    test.tv_sec = 0;
    test.tv_usec = RESPONSE_WAIT;
    fd_set descriptors;
    while (!this->window.empty()) {
        FD_ZERO(&descriptors);
        FD_SET(this->sockfd, &descriptors);
        int ready = select(this->sockfd + 1, &descriptors, NULL, NULL, &test);

        if (ready < 0)
            throw std::runtime_error("select error");

        if (ready != 0)
            receivePacket();

        if (ready == 0) {
            return;
        }
    }

}


void Transport::receivePacket(){

    sockaddr_in sender;
    socklen_t socklen = sizeof(sender);

    char buf[IP_MAXPACKET];
    int length = recvfrom(this->sockfd, buf, IP_MAXPACKET, MSG_DONTWAIT, (struct sockaddr *) &sender, &socklen);
    if (length < 0) {
        throw std::runtime_error("recvfrom error");
    }

    if (!validatePacket(sender))
        return;

    int start;
    int size;
    int items = sscanf(buf, "DATA %d %d\n", &start, &size);
    if (items != 2)
        throw std::runtime_error("sscanf error");

    int index = start / DATAGRAM_LEN - this->savedPacket;
    if (index < 0)
        return;

    if (this->window[index].start != start || this->window[index].size != size)
        throw std::runtime_error("Wrong index");

    if(this->window[index].ready)
        return;

    int offset = DATAGRAM_OFFSET + std::to_string(start).length() + std::to_string(size).length();
    this->window[index].saveToData(buf + offset);
    this->packetReceived++;
    save();

}

bool Transport::validatePacket(sockaddr_in sender) {
    return this->serverAddr.sin_addr.s_addr == sender.sin_addr.s_addr
           && this->serverAddr.sin_port == sender.sin_port;
}

void Transport::resendPacket(){
    for (int i = 0; i < this->window.size(); i++)
        this->window[i].sendRequest(this->sockfd, this->serverAddr);
}

void Transport::save(){

    while (!this->window.empty() && this->window.front().ready){

        this->window.front().saveToFile(this->fd);
        this->window.pop_front();
        this->savedPacket++;
        int packetLeft = this->packetAll - this->window.size() - this->savedPacket;


        int newStart = this->window.back().start + DATAGRAM_LEN;
        if(packetLeft == 1)
            this->window.push_back(Packet(newStart, fileSize % DATAGRAM_LEN));
        else if (packetLeft > 1 )
            this->window.push_back(Packet(newStart, DATAGRAM_LEN));

    }
}