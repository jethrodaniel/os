run: clean hex build
	qemu-system-x86_64 boot.bin

floppy: build
	qemu-system-x86_64 -fda boot.bin

build:
	as -o boot.o boot.s
	ld -o boot.bin --oformat binary -e main -Ttext 0x7c00 -o boot.bin boot.o
	if wc -c boot.bin 2>&1 >/dev/null; then echo "boot.bin is 512Mb, cool."; else echo "boot.bin isn't 512Mb"; fi

hex: build
	hexdump boot.bin

clean:
	rm -f *.o *.bin
