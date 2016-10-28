flex -o wordcount.cpp 1305112.l
g++ -std=c++11 wordcount.cpp -lfl -o wordcount.out
./wordcount.out input1.txt>>a.txt
