#include "csapp.h"

int main() {
    struct stat *buf = malloc(sizeof(struct stat));
    stat("./holes.bin", buf);
    printf("st_blksize: %d\n", buf->st_blksize); /* Block size for filesystem I/O */
    printf("st_stblocks: %d\n", buf->st_blocks); /* Number of 512B blocks allocated */
    printf("st_size: %d\n", buf->st_size); /* Total size, in bytes */
    printf("cl_size: %d\n", buf->st_blksize * buf->st_blocks);
}