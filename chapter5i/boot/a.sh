rm -rf ../boot.bin

nasm boot.asm -o boot.bin
cp boot.bin ..
cd ..
bochs -f b.txt

