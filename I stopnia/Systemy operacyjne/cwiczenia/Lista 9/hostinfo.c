#include "csapp.h"

int main(int argc, char **argv) {
  struct addrinfo *p, *listp, hints;
  char buf[MAXLINE];
  char buf2[MAXLINE];
  int rc, flags;

  if (argc != 2 && argc != 3)
    app_error("usage: %s <domain name>\n", argv[0]);

  /* Get a list of addrinfo records */
  memset(&hints, 0, sizeof(struct addrinfo));
  hints.ai_family = AF_UNSPEC;
  hints.ai_socktype = SOCK_STREAM;
  hints.ai_flags = AI_PASSIVE;
  /* Connections only */
  if ((rc = getaddrinfo(argv[1], argv[2], &hints, &listp)) != 0)
    gai_error(rc, "getaddrinfo");

  /* Walk the list and display each IP address */
  flags = NI_NUMERICHOST | NI_NUMERICSERV; /* Display address string instead of domain name */
  for (p = listp; p; p = p->ai_next) {
    Getnameinfo(p->ai_addr, p->ai_addrlen, buf, MAXLINE, buf2, MAXLINE, flags);
    printf("%s PORT: %s\n", buf, buf2);
  }

  /* Clean up */
  freeaddrinfo(listp);

  return EXIT_SUCCESS;
}
