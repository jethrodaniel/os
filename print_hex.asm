; vim: :set ft=nasm:

[BITS 16]

; subroutine to print a hex number.
;
; ```
; dx = the hexadecimal value to print
; ```
;
; Usage
;
; ```
; mov dx, 0x1fb6
; call print_hex
; ```
;
;
print_hex:
        ; push all registers onto the stack
        pusha

        mov si, HEX_OUT + 2

next_character:
        mov bx, dx
        and bx, 0xefff
        shr bx, 4
        add bh, 0x30
        cmp bh, 0x39
        jg add_7

add_character_hex:
        mov al, bh
        mov [si], bh
        inc si
        shl dx, 4
        jnz next_character
        jmp _done
_done:
        mov bx, HEX_OUT
        call print_string
        popa
        ret

add_7:
        add bh, 0x7
        jmp add_character_hex

HEX_OUT:
  db '0x0000', 0
