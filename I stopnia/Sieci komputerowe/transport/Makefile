CC = g++ -g
CFLAGS = -std=c++17

OBJS = transport.o main.o window.o datagram.o

traceroute: $(OBJS)
	$(CC) $(CFLAGS) -o transport $(OBJS)

main.o: main.cpp config.h
transport.o: transport.cpp transport.h
window.o: window.cpp window.h
datagram.o: datagram.cpp datagram.h

.PHONY: clean distclean

clean:
	rm -f *.o

distclean:
	make clean
	rm -f transport