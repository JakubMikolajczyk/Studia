CC = g++ -g
CFLAGS = -std=gnu++17

OBJS = transport.o main.o packet.o

traceroute: $(OBJS)
	$(CC) $(CFLAGS) -o transport $(OBJS)

main.o: main.cpp config.h
transport.o: transport.cpp transport.h
packet.o: packet.cpp packet.h

.PHONY: clean distclean

clean:
	rm -f *.o

distclean:
	make clean
	rm -f transport