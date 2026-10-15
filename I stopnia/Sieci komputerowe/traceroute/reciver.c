// Jakub Mikolajczyk 324504
#include "traceroute.h"

int recive_single(int sockfd, int ttl, int *ireply, struct timespec *times, struct in_addr *reply);
void calc_time_diff(struct timespec *start, struct timespec end);


void print_as_bytes (unsigned char* buff, ssize_t length)
{
	for (ssize_t i = 0; i < length; i++, buff++)
		printf ("%.2x ", *buff);	
}

// czekanie az wroca 3 pakiety lub minie czas
int recive3packet(int sockfd, int ttl, int *ireply, struct timespec *times, struct in_addr *reply) {

    struct timeval tv;
    tv.tv_sec = 1;
    tv.tv_usec = 0;
    int was_end = 0;
    for (;;) {

        fd_set descriptors;
        FD_ZERO(&descriptors);
        FD_SET(sockfd, &descriptors);

        int ready = select(sockfd + 1, &descriptors, NULL, NULL, &tv);

        if (ready < 0) {
            printf("select error: %s", strerror(errno));
            exit(EXIT_FAILURE);
        }

        if (ready == 0) // Koniec czekania
            return was_end;

        int ret = recive_single(sockfd, ttl, &*ireply, times, reply);

        if(ret == 1)   // Dotarlismy do celu
            was_end = 1;

        if (*ireply == 3)    // otrzymalismy wszystkie pakiety
            return was_end;

    }

}

// odczyt 1 pakietu z gniazda
int recive_single(int sockfd, int ttl, int *ireply, struct timespec *times, struct in_addr *reply) {
    struct sockaddr_in sender;
    socklen_t sender_len = sizeof(sender);
    u_int8_t buffer[IP_MAXPACKET];

    ssize_t packet_len = recvfrom(sockfd, buffer, IP_MAXPACKET, 0, (struct sockaddr *) &sender, &sender_len);

    struct timespec end_time;
    if (clock_gettime(CLOCK_MONOTONIC, &end_time) < 0) {
        printf("sendto clock_gettime error: %s", strerror(errno));
    }

    if (packet_len < 0) {
        printf("recvfrom error: %s", strerror(errno));
        exit(EXIT_FAILURE);
    }

    int pid = getpid() & 0x0000FFFF;

    struct ip *ip_header = (struct ip *) buffer;
    u_int8_t* icmp_packet = buffer + 4 * ip_header->ip_hl;
    struct icmp *icmp_header = (struct icmp *)icmp_packet;

    if (icmp_header->icmp_type == ICMP_TIMXCEED) {
›
        struct ip *ip_temp = (struct ip *)((uint8_t*)icmp_header + 8);
        struct icmp *icmp_header2 = (struct icmp *) ((uint8_t*)ip_temp + 4 * ip_temp->ip_hl);



        // 3 * ttl, poniewaz wysylamy 3 pakiety zatem seq dla ttl 1 - 3 4 5, ttl 2 - 6 7 8 ... nie musimy ograniczac z gory bo nie zostal wyslany jeszcze pakiet dla ttl 3
        if (icmp_header2->icmp_id == pid && icmp_header2->icmp_seq >= 3 * ttl) {
            printf("\n\n\n\n");
            print_as_bytes(buffer, 100);
            int idx = icmp_header2->icmp_seq % 3;
            reply[*ireply] = ip_header->ip_src; // ustawiamy kolejne adresy odpowiedzi
            calc_time_diff(&times[idx], end_time);  // czasy mierzymy dla konkretnego pakietu nie ma znaczenia ze w reply sa one ustawione w innej kolejnosci bo i tak bierzemy srednia
            (*ireply)++;
        }

    }

    if (icmp_header->icmp_type == ICMP_ECHOREPLY && icmp_header->icmp_id == pid &&
        icmp_header->icmp_seq >= 3 * ttl) {
        int idx = icmp_header->icmp_seq % 3;
        reply[*ireply] = ip_header->ip_src;
        (*ireply)++;
        calc_time_diff(&times[idx], end_time);
        printf("END");
        return 1;
    }

    return 0;
}


void calc_time_diff(struct timespec *start, struct timespec end) {

//    start->tv_sec = end.tv_sec - start->tv_sec;   // Czekamy przeciez < 1s zbedne
    start->tv_nsec = end.tv_nsec - start->tv_nsec;
}