# tell the assembler that we're using 16 bit mode (an x86 thing)
.code16

.global print_string

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
