# $^ - all of the target's dependency files
# $< - first dependency, $@ is target file
# $< - first dependency, $@ is target file
# $@ - target

CC = gcc
LD = ld
QEMU := qemu-system-i386

LD_FLAGS = -m elf_i386

PWD    := $(shell pwd)
PREFIX := $(PWD)/i386elfgcc
TARGET := i386-elf
PATH   := $(PREFIX)/bin:$(PATH)

C_SOURCES := $(wildcard kernel/*.c drivers/*.c)
HEADERS   := $(wildcard kernel/*.h drivers/*.h)
OBJ       := ${C_SOURCES:.c=.o}

C_FLAGS = -ffreestanding -nostdlib # bare-metal compilation
C_FLAGS += -g   # debugging support
C_FLAGS += -m32 # target i386

# commands

default: run

run: os.bin
	$(QEMU) -drive file=os.bin,index=0,if=floppy,format=raw

# open the connection to qemu and load our kernel-object file with symbols
debug: os.bin kernel.elf
	$(QEMU) -gdb tcp::9001 -fda os.bin &
	sudo $(GDB) -ex "target remote localhost:9001" \
	       -ex "symbol-file kernel.elf"

clean: clean_o
	rm -rf *.bin

clean_o:
	rm -rf *.o drivers/*.o kernel/*.o

purge: clean
	rm -rf tmp/

# files

kernel.elf: kernel_entry.o ${OBJ}
	$(LD) $(LD_FLAGS) -o $@ -Ttext 0x1000 $^

os.bin: boot.bin kernel.bin
	cat $^ > $@

kernel_entry.o: boot/kernel_entry.asm
	nasm $< -f elf -o $@

kernel.bin: kernel_entry.o ${OBJ}
	$(LD) $(LD_FLAGS) -o $@ -Ttext 0x1000 $^ --oformat binary

boot.bin: boot/boot.asm
	nasm -f bin -o $@ $<
	wc -c $@ # 512 todo,verify this

%.o : %.c ${HEADERS}
	$(CC) $(C_FLAGS) -c $< -o $@
