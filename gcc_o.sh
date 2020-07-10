gcc -E temp.c -o temp.i
gcc -S temp.i -o temp.s
gcc -c temp.s -o temp.o
