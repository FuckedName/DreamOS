gcc -c test.c 
gcc -c main2.c 
gcc  main2.o test.o -o main
./main

gcc readhzk.c
./a.out >test3.c
gcc test3.c


#cat HZK16_xxd_c32.txt | awk -F ": " '{ print $2 }' | awk -F "  " '{ print $1 }' | sed "s: ::g" | sed ":a;N;s/\n//g;ta"

#bin2obj -a HZK16 -c HZK16
#bin2obj HZK16 -a -c HZK16 >HZK.o
