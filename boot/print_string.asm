; vim: :set ft=nasm:

[BITS 16]

; subroutine to print a string.
;
; ```
; si = address of the null-terminated string
; ```
;
; Return:
;
; - sets al to each character, so al will be '0' on return
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

        ; int 10/ah = 0eh -> scrolling teletype BIOS routine
        mov ah, 0x0e ; put 0x0e into ah

print_char:
        ; loads the byte from the address in si into al and increments si
        mov al, [bx]
        inc bx

        ; compares content in AL with zero
        cmp al, 0

        ; if al == '0', go to "done"
        je done

        ; prints the character in al to screen
        int 0x10

        ; repeat with the next byte
        jmp print_char
done:
        ; stop execution

        ; pop all registers off the stack
        popa

        ; return from the subroutine
        ret
