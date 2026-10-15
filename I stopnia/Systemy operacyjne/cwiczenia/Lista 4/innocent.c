#include "csapp.h"
#include "dirent.h"
const int bufLen = 1000;

int main(void) {
  long max_fd = sysconf(_SC_OPEN_MAX);
  int out = Open("/tmp/hacker", O_CREAT | O_APPEND | O_WRONLY, 0666);

  /* TODO: Something is missing here! */
    system("ls /dev/fd");
  DIR *dir = opendir("/dev/fd");
    chdir("/dev/fd");
  struct dirent *dp;

    while ((dp = readdir(dir)) != NULL){
        char buf[bufLen];
        printf("Path: %s\n", dp->d_name);
        ssize_t temp = readlink(dp->d_name,buf, 999);
        printf("Temp: %d\n", temp);
        printf("Buf: %s\n", buf);
    }

//  for (int i = max_fd; i > 2; i--){
//      char buf[bufLen];
////      int i = 5;
//      char filePath[PATH_MAX];
//      if(fcntl(i, F_GETPATH, filePath) != -1 && i != out) {
//          dprintf(out,"FD: %d   %s\n", i, filePath);
//          off_t t = lseek(i, 0, SEEK_SET);
//          read(i,&buf,255);
//          buf[bufLen - 1] = '\0';
//          write(out, buf, 255);
//      }
//  }



//  printf("%ld \n %d\n\n\n", max_fd, out);

  Close(out);

  printf("I'm just a normal executable you use on daily basis!\n");

  return 0;
}
