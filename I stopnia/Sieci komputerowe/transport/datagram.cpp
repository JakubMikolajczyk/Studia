#include "datagram.h"


void Datagram::sendRequest(int sockfd, sockaddr_in serverAddr) {
    std::string msg = "GET " + std::to_string(this->start) + " " + std::to_string(this->size) + "\n";
//    printf("%s\n", msg.c_str());
    if (sendto(sockfd, msg.c_str(), msg.length(), 0, (struct sockaddr*) &serverAddr, sizeof(serverAddr)) < 0) {
        throw std::runtime_error("sendto error");
    }
    if (clock_gettime(CLOCK_MONOTONIC, &this->send_time) < 0) {
        throw std::runtime_error("sendto clock_gettime error");
    }

}

void Datagram::tryResend(int sockfd, sockaddr_in serverAddr) {

    if(this->ready)
        return;

    timespec now;
    now.tv_sec = 0;
    now.tv_nsec = 0;
    if (clock_gettime(CLOCK_MONOTONIC, &now) < 0) {
        throw std::runtime_error("resend clock_gettime error");
    }

    now.tv_sec = now.tv_sec - this->send_time.tv_sec;
    if (now.tv_sec > RESEND_TIME || this->send_time.tv_sec == 0 )
        sendRequest(sockfd, serverAddr);

}

void Datagram::saveToFile(int fd) {

    if (write(fd, this->data, this->size) != this->size)
        throw std::runtime_error("Write error");

}