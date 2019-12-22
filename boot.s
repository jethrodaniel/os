# boot.s: the bootloader
#
# ### What is a bootloader?
#
# When your computer boots up, it starts the BIOS (Basic Input/Output System),
# which:
#
# - performs hardware tests (memory checks)
# - enables changing various settings
# - prints logo, diagnostic, etc
# - attempts to load an operating system from any bootable media
#
# When trying to load an OS, the BIOS reads the first 512 bytes from the boot
# devices and checks if the last two of these 512 bytes contain `0x55AA`. If so,
# the BIOS moves the 512 bytes to the memory address `0x7c00` and treats whatever
# was at the beginning of the 512 bytes as code, i.e, the bootloader.
#
# Run with
#
# ```
# as -o boot.o boot.s
# ld -o boot.bin \
#    --oformat binary \
#    -e main -Ttext 0x7c00 \
#    -o boot.bin boot.o
# qemu-system-x86_64 boot.bin
# ```
#
# note:
# - the binary format, because ld typically makes ELF files
# - the text directive tells the assembler that we want our text segment
#   to be available at `0x7c00`, which is were the BIOS will place our
#   bootloader
#
# ### x86 assembly basics
#
# - 8 general purpose 32-bit registers
#
# - general purpose registers:
#   - eax
#   - ebx
#   - ecx, sometimes is a "counter"
#   - edx
#
# - for the stack frame
#   - ebp - stack base pointer
#   - esp - stack pointer
#
# - for memory compying
#   - edi - destination index
#   - esi - source index
#
# the annoying `e` prefix means extended, since this is 32 bit, not 16.

# tell the assembler that we're using 16 bit mode (an x86 thing)
.code16

# make our label `main` available to the outside.
# Typically this is called `_start`.
.global main

main:
        # loads the address of msg into register si
        mov $msg, %si
        # loads 0xe (function number for int 0x10) into ah
        mov $0xe, %ah
print_char:
        # loads the byte from the address in si into al and increments si
        lodsb
        # compares content in AL with zero
        cmp $0, %al
        # if al == 0, go to "done"
        je done
        # prints the character in al to screen
        int $0x10
        # repeat with the next byte
        jmp print_char
done:
  # stop execution
  hlt

# stores the string (plus a byte with value "0") and gives us access via $msg
msg:
        .asciz "Hello world!"

# add zeroes to make it 510 bytes long
.fill 510-(.-main), 1, 0

# Add the magic `0x55aa`, but since x86 is little-endian, swap the bytes
.word 0xaa55 # magic bytes that tell BIOS that this is bootable
