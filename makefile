QEMU := qemu-system-x86_64

default: run

run: boot.bin
	$(QEMU) -drive file=$<,index=0,if=floppy,format=raw

boot.bin: os.asm
	nasm -f bin -o $@ $<
	wc -c $@ # 512 todo,verify this

clean:
	rm -rf *.bin build

build:
	mkdir -p build
build/forth: build
	gcc forth.c -Wall -o $@
forth: build/forth
	./$<
