; vim: :set ft=nasm:

[BITS 32]

; subroutine to print a string in VGA mode, without the BIOS.
;
; ```
; edx = address of the null-terminated string
; ```
;
; Usage
;
; ```
; mov edx, msg
; call print_string_vga
;
; msg: db "yo", 0
; ```
;

VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; print a null-terminated string pointed to by edx
print_string_vga:
        pusha

        ; set  edx to the start of vid mem
        mov edx, VIDEO_MEMORY

print_string_vga_loop:
        ; store the char in ebx into al
        mov al, [ebx]

        ; store the attributes in ah
        mov ah, WHITE_ON_BLACK

        ; if al == 0, then end of string, so jump to done
        cmp al, 0
        je done

        ; store char and attributes at curent char cell
        mov [edx], ax

        ; increment ebx to the next char in the string
        add ebx, 1

        ; move to the next char cell in video memory
        add edx, 2

        ; loop
        jmp print_string_vga_loop

print_string_vga_done:
        popa
        ret
