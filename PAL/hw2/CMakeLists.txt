cmake_minimum_required(VERSION 3.15)
project(hw2)

set(CMAKE_CXX_STANDARD 11)

include_directories(.)

add_executable(hw2
        AdjacencyList.cpp
        AdjacencyList.h
        Graph.cpp
        Graph.h
        main.cpp
        utils.h)
