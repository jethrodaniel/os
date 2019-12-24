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

run: os.img
	qemu-system-x86_64 -fda os.img

os.img: boot.bin kernel.bin
	cat $^ > os.img

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

# todo
#
# # https://stackoverflow.com/a/34275054/7132678
# # todo: `print_hex` prints 0s here?
# iso: build
# 	# make a sero filled disk image the size of a floppy (1.44MB)
# 	dd if=/dev/zero of=floppy.img bs=1024 count=1440
# 	# place boot.bin into that disk image without truncating the rest
# 	dd if=boot.bin of=floppy.img seek=0 count=1 conv=notrunc
# 	# make the iso
# 	mkdir -p iso
# 	cp floppy.img iso/
# 	genisoimage -quiet -input-charset iso8859-1 -o os.iso -b floppy.img -hide floppy.img iso/
# 	qemu-system-x86_64 -cdrom ./os.iso

# to boot from usb:
#
# ```
# # insert your usb
# make build
# sudo fdisk -l # find the mount point, i.e, /sdbx, where x is 1,2,3,...
# mount | grep sd
#
# # run the usb
# sudo qemu-system-x86_64 -hdb /dev/sdb1
# ```


