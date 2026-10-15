cmake_minimum_required(VERSION 3.21)
project(traceroute C)

set(CMAKE_C_STANDARD 17)

add_executable(traceroute traceroute.h traceroute.c sender.c reciver.c main.c)
