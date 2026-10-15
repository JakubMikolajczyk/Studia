#ifndef traceroute_h
#define traceroute_h

#include <stdio.h>
#include <arpa/inet.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <assert.h>
#include <netinet/ip.h>
#include <netinet/ip_icmp.h>
#include <sys/types.h>
#include <unistd.h>

void traceroute(int sockfd, struct sockaddr_in recipient);
int send3packet(int sockfd, struct sockaddr_in addr, int ttl, struct timespec *times);
int recive3packet(int sockfd, int ttl, int *ireply, struct timespec *times, struct in_addr *reply);

#endif