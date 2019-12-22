run: clean hex build
	qemu-system-x86_64 boot.bin

floppy: build
	qemu-system-x86_64 -fda boot.bin

build:
	as -o boot.o boot.s
	ld -o boot.bin --oformat binary -e main -Ttext 0x7c00 -o boot.bin boot.o
	wc -c boot.bin

hex: build
	hexdump boot.bin

clean:
	rm -f *.o *.bin
