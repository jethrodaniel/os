

gas: clean hex build
	qemu-system-x86_64 boot.bin

nasm: clean hex-nasm build-nasm
	qemu-system-x86_64 boot-nasm.bin

# floppy: build
# 	qemu-system-x86_64 -fda boot.bin

build:
	as -o boot.o boot.s
	ld -o boot.bin --oformat binary -e _start -Ttext 0x7c00 -o boot.bin boot.o
	wc -c boot.bin
build-nasm:
	nasm -f bin -o boot-nasm.bin boot.asm
	wc -c boot-nasm.bin

hex: build
	hexdump -v boot.bin
hex-nasm: build-nasm
	hexdump -v boot-nasm.bin

clean:
	rm -f *.o *.bin
