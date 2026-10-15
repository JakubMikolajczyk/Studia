// Jakub Mikolajczyk 324504
#include "traceroute.h"

struct icmp create_icmp(int seq);
u_int16_t compute_icmp_checksum(const void *buff, int length);


int send3packet(int sockfd, struct sockaddr_in recipient, int ttl, struct timespec *times) {


    for (int seq = 0; seq < 3; seq++) {
        setsockopt(sockfd, IPPROTO_IP, IP_TTL, &ttl, sizeof(ttl));
        int packet_seq = ttl * 3 + seq;  // Chcemy miec mozliwosc identyfikacji poszczegolnych pakietow, do mierzenia czasu odpowiedzi
        struct icmp header = create_icmp(packet_seq);
        ssize_t ret = sendto(sockfd, &header, sizeof(header), 0, (struct sockaddr *) &recipient, sizeof(recipient));
        if(clock_gettime(CLOCK_MONOTONIC, &times[seq]) < 0){
            printf("sendto clock_gettime error: %s", strerror(errno));
        }

        if (ret < 0) {
            printf("sendto error: %s", strerror(errno));
            exit(EXIT_FAILURE);
        }

    }

    return 0;
}


struct icmp create_icmp(int seq) {
    struct icmp header;

    header.icmp_type = ICMP_ECHO;
    header.icmp_code = 0;
    header.icmp_hun.ih_idseq.icd_id = getpid();
    header.icmp_hun.ih_idseq.icd_seq = seq;
    header.icmp_cksum = 0;
    header.icmp_cksum = compute_icmp_checksum((u_int16_t *) &header, sizeof(header));

    return header;
}

// funkcja z wykladu
u_int16_t compute_icmp_checksum(const void *buff, int length) {

    u_int32_t sum;
    const u_int16_t *ptr = buff;
    assert (length % 2 == 0);
    for (sum = 0; length > 0; length -= 2)
        sum += *ptr++;

    sum = (sum >> 16) + (sum & 0xffff);
    return (u_int16_t) (~(sum + (sum >> 16)));
}