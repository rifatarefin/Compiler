bison -d -y abc.y
echo '1'
g++ -std=c++11 -w -c -o y.o y.tab.c
echo '2'
flex -o a.cpp scanner.l
echo '3'
g++ -std=c++11 -w -c -o l.o a.cpp
# if the above command doesn't work try g++ -fpermissive -w -c -o l.o lex.yy.c
echo '4'
g++ -o a.out y.o l.o -lfl -ly 
echo '5'
./a.out 
