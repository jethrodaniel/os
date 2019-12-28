# $^ - all of the target's dependency files
# $< - first dependency, $@ is target file
# $< - first dependency, $@ is target file

C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS   = $(wildcard kernel/*.h drivers/*.h)
OBJ       = ${C_SOURCES:.c=.o}

C_FLAGS = -ffreestanding -nostdlib -nostdinc -fno-builtin -fno-stack-protector -nostartfiles -nodefaultlibs

default: run

info:
	@echo "== build info =="
	@echo "sources: $(C_SOURCES)"
	@echo "headers: $(HEADERS)"
	@echo "obj: $(OBJ)"

run: os.bin
	qemu-system-x86_64 -drive file=os.bin,index=0,if=floppy,format=raw

os.bin: boot.bin kernel.bin
	cat $^ > os.bin

%.o : %.c ${HEADERS}
	gcc $(C_FLAGS) -c $< -o $@

kernel_entry.o: boot/kernel_entry.asm
	nasm $< -f elf64 -o $@

kernel.bin: kernel_entry.o ${OBJ}
	ld -o $@ -Ttext 0x1000 $^ --oformat binary

boot.bin: boot/boot.asm
	nasm -f bin -o boot.bin boot/boot.asm
	wc -c boot.bin

clean:
	rm -rf *.o *.bin *.img *.iso iso/ drivers/*.o kernel/*.o
