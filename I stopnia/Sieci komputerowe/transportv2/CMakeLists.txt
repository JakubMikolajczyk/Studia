cmake_minimum_required(VERSION 3.21)
project(transportv2)

set(CMAKE_CXX_STANDARD 17)

add_executable(transportv2 main.cpp transport.cpp transport.h packet.cpp packet.h)
