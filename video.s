# tell the assembler that we're using 32 bit mode (no BIOS)
.code32

.set VIDEO_MEMORY, 0xb8000
.set WHITE_ON_BLACK, 0x0f

# print a null-terminated string pointed to by edx
print_string_pm:
        pusha
        # et  edx to the  start  of vid  mem
        mov VIDEO_MEMORY, %edx

print_string_pm_loop:
        # store the char in ebx into al
        mov %al, (%ebx)

        # store the attributes in ah
        mov %ah, WHITE_ON_BLACK

        # if al == 0, then end of string, so jump to done
        cmp %al, 0
        je done

        # store char and attributes at curent char cell
        mov %ax, (%ebx)

        # increment ebx to the next char in the string
        add 1, %ebx

        # move to the next char cell in video memory
        add 2, %edx

        # loop
        jmp print_string_pm_loop

print_string_pm_done:
        popa
        ret
