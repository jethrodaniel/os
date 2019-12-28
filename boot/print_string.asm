; vim: :set ft=nasm:

[bits 16]

; subroutine to print a string
;
; ```
; bx = address of the null-terminated string
; ```
;
; Usage
;
; ```
; mov bx, msg
; call print_string
;
; msg: db "yo", 0
; ```
;
print_string:
        ; push all registers onto the stack
        pusha

        ; tty mode
        mov ah, 0x0e

print_char:
        ; load the next byte from bx into al for printing
        mov al, [bx]
        inc bx

        ; if al == '0', go to "done"
        cmp al, 0
        je done

        ; print the character in al to screen
        int 0x10

        ; repeat with the next byte
        jmp print_char

done:
        ; pop all registers off the stack
        popa

        ; return from the subroutine
        ret
