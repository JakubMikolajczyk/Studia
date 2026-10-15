#include <iostream>
#include <fcntl.h>
#include <fstream>
#include "transport.h"

int main(int argc, char *argv[]) {


    try {
        if (argc != 5)
            throw std::invalid_argument("Usage: ip port output_file bytes");

        int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
        if (sockfd < 0)
            throw std::runtime_error("socket error");

        sockaddr_in serverAdrr;
        bzero(&serverAdrr, sizeof(serverAdrr));

        serverAdrr.sin_family = AF_INET;
        if(inet_pton(AF_INET, argv[1], &serverAdrr.sin_addr) < 0)
            throw std::runtime_error("Invalid ip address");

        serverAdrr.sin_port = htons(std::stol(argv[2]));
        if (serverAdrr.sin_port == 0)
            throw std::runtime_error("Invalid port");

        int fd = open(argv[3], O_WRONLY | O_CREAT | O_TRUNC);
        if(fd < 0)
            throw std::runtime_error("file open error");

        int fileSize = std::stoi(argv[4]);

        Transport transport = Transport(fd, sockfd, serverAdrr, fileSize);
        transport.download();

        close(fd);
        close(sockfd);
    }
    catch (std::exception &e) {
        std::cout << e.what();
    }

    return 0;
}
