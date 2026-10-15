cmake_minimum_required(VERSION 3.21)
project(transport)

set(CMAKE_CXX_STANDARD 17)

add_executable(transport main.cpp datagram.cpp datagram.h config.h window.cpp window.h transport.cpp transport.h)
