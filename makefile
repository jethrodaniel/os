# $^ - all of the target's dependency files
# $< - first dependency, $@ is target file
# $< - first dependency, $@ is target file
# $@ - target

CC   := ./i386elfgcc/bin/i386-elf-gcc
GDB  := ./i386elfgcc/bin/i386-elf-gdb
LD   := ./i386elfgcc/bin/i386-elf-ld
QEMU := qemu-system-i386

BINUTILS_VERSION = 2.33.1
GCC_VERSION = 9.2.0
GDB_VERSION = 8.2

PWD    := $(shell pwd)
PREFIX := $(PWD)/i386elfgcc
TARGET := i386-elf
PATH   := $(PREFIX)/bin:$(PATH)

C_SOURCES := $(wildcard kernel/*.c drivers/*.c)
HEADERS   := $(wildcard kernel/*.h drivers/*.h)
OBJ       := ${C_SOURCES:.c=.o}

# bare-metal compilation
C_FLAGS = -ffreestanding \
          -nostdlib
          # -lgcc

# debugging support
C_FLAGS += -g

# commands

default: run

info:
	@echo "== build info =="
	@echo "sources: $(C_SOURCES)"
	@echo "headers: $(HEADERS)"
	@echo "obj: $(OBJ)"

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
	$(LD) -o $@ -Ttext 0x1000 $^

os.bin: boot.bin kernel.bin
	cat $^ > $@

kernel_entry.o: boot/kernel_entry.asm
	nasm $< -f elf -o $@

kernel.bin: kernel_entry.o ${OBJ}
	$(LD) -o $@ -Ttext 0x1000 $^ --oformat binary

boot.bin: boot/boot.asm
	nasm -f bin -o $@ $<
	wc -c $@ # 512 todo,verify this

%.o : %.c ${HEADERS}
	$(CC) $(C_FLAGS) -c $< -o $@

# cross-compiler
#
cross-compiler: tmp/src binutils gcc gdb

tmp/src:
	mkdir -p $@

gdb: tmp/src/gdb-$(GDB_VERSION) tmp/src/gdb-build
	cd ./tmp/src/gdb-build && \
  ../gdb-$(GDB_VERSION)/configure --target="$(TARGET)" \
	                                --prefix="$(PREFIX)" \
																	--program-prefix=i386-elf- \
																	--with-guile=no && \
  make && \
  make install
tmp/src/gdb-$(GDB_VERSION): tmp/src/gdb-$(GDB_VERSION).tar.gz
	cd ./tmp/src && \
  tar xf gdb-$(GDB_VERSION).tar.gz
tmp/src/gdb-$(GDB_VERSION).tar.gz:
	cd ./tmp/src && \
  curl -O https://ftp.gnu.org/gnu/gdb/gdb-$(GDB_VERSION).tar.gz
tmp/src/gdb-build:
	mkdir -p $@

gcc: gcc-prereqs tmp/src/gcc-build
	cd ./tmp/src/gcc-build && \
  ../gcc-$(GCC_VERSION)/configure --target=$(TARGET) \
	                                --prefix="$(PREFIX)" \
																	--disable-nls \
																	--disable-libssp \
																	--enable-languages=c \
																	--without-headers && \
	make all-gcc && \
	make all-target-libgcc && \
  make install-gcc && \
  make install-target-libgcc
gcc-prereqs: tmp/src/gcc-$(GCC_VERSION)
	cd ./tmp/src/gcc-$(GCC_VERSION) && \
  ./contrib/download_prerequisites
tmp/src/gcc-$(GCC_VERSION): tmp/src/gcc-$(GCC_VERSION).tar.gz
	cd ./tmp/src && \
  tar xf gcc-$(GCC_VERSION).tar.gz
tmp/src/gcc-$(GCC_VERSION).tar.gz:
	cd ./tmp/src && \
  curl -f -L0 -O https://ftp.gnu.org/gnu/gcc/gcc-$(GCC_VERSION)/gcc-$(GCC_VERSION).tar.gz
tmp/src/gcc-build:
	mkdir -p $@

binutils: tmp/src/binutils-$(BINUTILS_VERSION) tmp/src/binutils-build
	cd ./tmp/src/binutils-build && \
  ../binutils-$(BINUTILS_VERSION)/configure --target="$(TARGET)" \
	                                          --enable-interwork \
																						--enable-multilib \
																						--disable-nls \
																						--disable-werror \
																						--prefix="$(PREFIX)" 2>&1 && \
  make all install 2>&1 | tee make.log
tmp/src/binutils-$(BINUTILS_VERSION): tmp/src/binutils-$(BINUTILS_VERSION).tar.gz
	cd ./tmp/src && \
	tar xf binutils-$(BINUTILS_VERSION).tar.gz
tmp/src/binutils-$(BINUTILS_VERSION).tar.gz:
	cd ./tmp/src && \
  curl -f -L0 -O https://ftp.gnu.org/gnu/binutils/binutils-$(BINUTILS_VERSION).tar.gz
tmp/src/binutils-build:
	mkdir -p $@
