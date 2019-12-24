default: kernel

kernel: build
	gcc -ffreestanding -c c/kernel.c -o kernel.o
	ld -o kernel.bin -Ttext 0x1000 kernel.o --oformat binary
	cat boot.bin kernel.bin > os.img
	qemu-system-x86_64 -fda os.img

build:
	nasm -f bin -o boot.bin asm/boot.asm
	wc -c boot.bin

hex: build
	hexdump -v boot.bin

clean:
	rm -rf *.o *.bin *.img *.iso iso/

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


