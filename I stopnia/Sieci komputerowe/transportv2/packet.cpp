#include "packet.h"


Packet::Packet(int start, int size) :
    start(start),
    size(size),
    ready(false){}


void Packet::sendRequest(int sockfd, sockaddr_in serverAddr) {
    std::string msg = "GET " + std::to_string(this->start) + " " + std::to_string(this->size) + "\n";
//    printf("%s\n", msg.c_str());
    if (sendto(sockfd, msg.c_str(), msg.length(), 0, (struct sockaddr*) &serverAddr, sizeof(serverAddr)) < 0) {
        throw std::runtime_error("sendto error");
    }

}

void Packet::saveToData(char *buf){
    std::copy(buf, buf + this->size, this->data);
    this->ready = true;
}

void Packet::saveToFile(int fd) {

    if (write(fd, this->data, this->size) != this->size)
        throw std::runtime_error("Write error");

}