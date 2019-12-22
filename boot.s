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
# the BIOS moves the 512 bytes to the memory address `0x7c00` and treats
# them as code.
#
# So it's important that this code actually take control, lest the CPU eat
# all the memory until something grinds to a halt.
#
# Run this with
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
# - `--oformat binary`, because ld typically makes ELF files
# - `-e main -Ttext 0x7c00`- tell the assembler that we want our text segment
#   to be available at `0x7c00`, which is were the BIOS will place our
#   bootloader, and that we
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
# intel loves backward-compatability, so all the intel-compatible CPUS emulate
# the oldest one, the 8086, which was 16-bit with no memory protection.
#
# the annoying `e` prefix means extended, since this is 32 bit, not 16.
#
# like so:
#
# ```
# register eax
#
# 31                   15                       0
# +---------------------|-----------------------+
# |                     |         ax            |
# +---------------------|-----------------------+
#
# ---------------- eax -------------------------
# ```
#
# invoke a BIOS routine:
#  - set eax to a BIOS defined value
#  - trigger a specific interrupt

# BIOS routines used:
#
# - print char to screen: http://www.ctyme.com/intr/rb-0106.htm
#
# ```
# ah = 0eh
# al = character to write
# bh = page number
# bl = foreground color (graphics modes only)
#
# return:
# nothing
# ```
#

# ---

# tell the assembler that we're using 16 bit mode (an x86 thing)
.code16

# make our label `main` available to the outside.
# Typically this is called `_start`.
.global main

#
# .text
#

main:
        # loads the address of msg into register si
        mov $msg, %si
        call print_string

# subroutine to print a string.
#
# ```
# si = address of the null-terminated string (byte array)
# ```
#
print_string:
        # push all registers onto the stack
        pusha

        # loads 0xe (function number for int 0x10) into ah
        mov $0xe, %ah

print_char:
        # loads the byte from the address in si into al and increments si
        lodsb

        # compares content in AL with zero
        cmp $0, %al

        # if al == '0', go to "done"
        je done

        # prints the character in al to screen
        int $0x10

        # repeat with the next byte
        jmp print_char
done:
        # stop execution

        # pop all registers off the stack
        pusha

        # return from the subroutine
        ret

#
# .data
#

# stores the string (plus a byte with value "0") and gives us access via $msg
msg:
        .asciz "Hello world!"

# pad the assembler's outputed binary with zeroes to make it 510 bytes long
.fill 510-(.-main), 1, 0

# Add the magic `0x55aa` that tells the BIOS we're a boot sector, but since
# x86 is little-endian, swap the bytes
.word 0xaa55
