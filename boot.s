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
#    -e _start -Ttext 0x7c00 \
#    -o boot.bin boot.o
# qemu-system-x86_64 boot.bin
# ```
#
# note:
# - `--oformat binary`, because ld typically makes ELF files
# - `-e _start -Ttext 0x7c00`- tell the assembler that we want our text segment
#   to be available at `0x7c00`, which is were the BIOS will place our
#   bootloader, and that the entry point is _start.
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
# the annoying `e` prefix means extended, i.e, 32 bit, not 16.
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
# some essentials
#
# - mov source dest
# - movb source dest # move byte
# - movw source dest # move word (16-bit)
# - movl source dest # move word (32-bit)
#
# invoke a BIOS routine:
#  - set eax to a BIOS defined value
#  - trigger a specific interrupt
#
# BIOS routines used:
#
# - print char to screen: http://www.ctyme.com/intr/rb-0106.htm
#
# ```
# ah = 0eh
# al = character to write
# bh = page number
# bl = foreground color (graphics modes only)
# ```
#
# ---

# use 16 bit real mode
.code16

# make our label `_start` available to the outside.
.global _start

# start our code
.text

_start:
        # load the address of msg into register si
        mov $msg, %si
        call print_string

        /* mov $0x0, %si */
        /* call print_hex */

        # Loop here forever
loop:
        jmp _start

# include our subroutines
.include "print_string.s"

# store a string (plus a '\0')
msg:
        .asciz "Hello world!"

# pad the assembler's outputed binary with zeroes to make it 510 bytes long
.fill 510-(.-_start), 1, 0

# Add the magic `0x55aa` that tells the BIOS we're a boot sector, but since
# x86 is little-endian, swap the bytes
.word 0xaa55
