CC=g++
CC_FLAGS=-std=c++11 -pipe -Wall -O3
SRC=$(wildcard *.cpp)
OBJ=$(patsubst %.cpp, %.o, $(SRC))
main: $(OBJ)
	$(CC) $(CC_FLAGS) $(OBJ) -o main

%.o: %.cpp
	$(CC) $(CC_FLAGS) -c $< -o $@

clean:
	rm *.o main