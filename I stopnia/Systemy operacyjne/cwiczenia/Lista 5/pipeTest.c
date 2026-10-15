#include "csapp.h"

int main(int argc, char *argv[]) {

    char * myfifo = "/tmp/myfifo";

    pid_t pid = Fork();
    mkfifo(myfifo, 0666);
    char buf[10];
    int fd;
    if(pid){
        fd = open(myfifo, O_RDONLY);
        read(fd, buf, 9);
        buf[9] = '\0';
        printf("READ: %s\n", buf);
    } else{

        fd = open(myfifo, O_WRONLY);
        write(fd,"012345678",9);
    }

    close(fd);

    return 0;

}