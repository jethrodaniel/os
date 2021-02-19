QEMU := qemu-system-x86_64
USB  := /dev/sdb

default: run

run: boot.bin
	$(MAKE) -C reference
	$(QEMU) -drive file=$<,index=0,if=floppy,format=raw
	# $(QEMU) -hda /dev/sdb
	# $(QEMU) -cdrom /dev/sdb

usb: boot.bin
	sudo dd if=./$< of=$(USB) status=progress

boot.bin: os.asm asm/monitor.asm
	nasm -f bin -o $@ $<
	wc -c $@ # 512 todo,verify this

clean:
	rm -rf *.bin build

# https://github.com/jethrodaniel/z
asm/monitor.asm:
	ZARCH=x86_16 z compile monitor.c > $@
