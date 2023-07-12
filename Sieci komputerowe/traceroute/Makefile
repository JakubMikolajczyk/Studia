CC = gcc -g
CFLAGS = -Wall -Werror -std=gnu99

OBJS = traceroute.o main.o sender.o reciver.o

traceroute: $(OBJS)
	$(CC) $(CFLAGS) -o traceroute $(OBJS)

main.o: main.c traceroute.h
traceroute.o: traceroute.c traceroute.h
sender.o: sender.c traceroute.h
reciver.o: reciver.c traceroute.h

.PHONY: clean distclean

clean:
	rm -f *.o

distclean:
	make clean
	rm -f traceroute