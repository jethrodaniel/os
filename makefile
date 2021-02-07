QEMU := qemu-system-x86_64

default: run

# Note:
#
# If you have the misfortune to run `dd` here when the usb drive is **not**
# present, it will create a normal file, not a block special.
#
# If you check `file /dev/sdb` and it's not block special, you've got a
# problem. `rm -rf` that file, then reinsert the usb drive and confirm that
# `file` shows block device.
#
# Then zero out the drive and write over the boot image.
#
# ```
# $ file /dev/sdb
# /dev/sdb: data
#
# $ rm -rf file /dev/sdb
#
# # reinsert usb
#
# $ file /dev/sdb
# /dev/sdb: block special
#
# $ sudo dd if=/dev/zero of=/dev/sdb status=progress
# $ sudo dd if=./boot.bin of=/dev/sdb status=progress
# ```
#
run: boot.bin
	$(QEMU) -drive file=$<,index=0,if=floppy,format=raw
	# sudo dd if=./boot.bin of=/dev/sdb status=progress
	# $(QEMU) -hda /dev/sdb
	# $(QEMU) -cdrom /dev/sdb

boot.bin: os.asm
	nasm -f bin -o $@ $<
	wc -c $@ # 512 todo,verify this

clean:
	rm -rf *.bin build
