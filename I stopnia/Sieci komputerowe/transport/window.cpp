#include "window.h"

Window::Window(int fd, int sockfd, sockaddr_in serverAddr, int packets, int lastPacket) :
        fileSize(packets * DATAGRAM_LEN + lastPacket),
        fd(fd),
        sockfd(sockfd),
        serverAddr(serverAddr){

    std::cout << "AFASGSAGASGSAGAS    " << packets << " \n";

    for (int i = 0; i < (packets + 1) && i < WINDOW_SIZE; i++) {
        this->datagrams[i].start = i * DATAGRAM_LEN;
        this->datagrams[i].send_time.tv_sec = 0;
    }

    if ((packets + 1) != WINDOW_SIZE) {
        this->end = packets;
        this->datagrams[packets].size = lastPacket;
    }
}

int Window::next(int val) {
    return (val + 1) % WINDOW_SIZE;
}

int Window::prev(int val) {
    return (val - 1) % WINDOW_SIZE;
}

Datagram *Window::getFirstDatagram() {
    return &this->datagrams[this->begin];
}

Datagram *Window::getLastDatagram() {
    return &this->datagrams[this->end];
}


Datagram *Window::findDatagram(int start) {    //seems to work
    int moveVal = (start - this->datagrams[this->begin].start) / DATAGRAM_LEN;
    int index = (this->begin + moveVal) % WINDOW_SIZE;
    return &this->datagrams[abs(index)];
}

void Window::receiveDatagram(int start, int size, char *buf) {

    Datagram *temp = findDatagram(start);
    if (temp->ready)
        return;

    if (temp->start != start)
        printf("Wrong datagram find.start: %d, start: %d, begin: %d \n", temp->start, start, this->begin);
//        throw std::runtime_error("Wrong datagram");

    if (size != temp->size) {
        printf("SIZE: %d SSIZE: %d\n", size, temp->size);
        throw std::runtime_error("Something go wrong, receive diffrent size than expected");
    }

    std::copy(buf, buf + size, temp->data);
    temp->ready = true;
    this->packetReceive++;
    trySave();
}

bool Window::canSaveFirst() {
    return getFirstDatagram()->ready;
}


void Window::trySave() {

    while (canSaveFirst() && this->fileSize != 0) {
        Datagram* first = getFirstDatagram();
        first->saveToFile(this->fd);
        this->fileSize -= first->size;

        // optymalizacja
        if (this->fileSize > WINDOW_SIZE * DATAGRAM_LEN) {
            first->start = getLastDatagram()->start + getLastDatagram()->size;
            first->size = this->fileSize > DATAGRAM_LEN ? DATAGRAM_LEN : this->fileSize;
            first->ready = false;
//            first->sendRequest(this->sockfd, this->serverAddr);
            this->end = this->begin;
        }
        this->range = getFirstDatagram()->start;
        this->begin = next(this->begin);
    }

}

void Window::tryResend() {

    for (int cursor = this->begin; cursor != this->end; cursor = next(cursor))
        this->datagrams[cursor].tryResend(this->sockfd, this->serverAddr);

    this->datagrams[this->end].tryResend(this->sockfd, this->serverAddr);
}

bool Window::isEnd() {
    return this->fileSize == 0;
}