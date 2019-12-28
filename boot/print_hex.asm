; vim: :set ft=nasm:

[bits 16]

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
; used as an answer here: https://stackoverflow.com/a/27686875/7132678
;
print_hex:
        ; push all registers onto the stack
        pusha

        ; use si to keep track of the current char in our template string mov si, HEX_OUT + 2
        mov si, HEX_OUT + 2

        ; start a counter of how many nibbles we've processed, stop at 4
        mov cx, 0

next_character:
        ; increment the counter for each nibble
        inc cx

        ; isolate this nibble
        mov bx, dx
        and bx, 0xf000
        shr bx, 4

        ; add 0x30 to get the ASCII digit value
        add bh, 0x30

        ; If our hex digit was > 9, it'll be > 0x39, so add 7 to get
        ; ASCII letters
        cmp bh, 0x39
        jg add_7

add_character_hex:
        ; put the current nibble into our string template
        mov [si], bh

        ; increment our template string's char position
        inc si

        ; shift dx by 4 to start on the next nibble (to the right)
        shl dx, 4

        ; exit if we've processed all 4 nibbles, else process the next
        ; nibble
        cmp cx, 4
        jnz next_character
        jmp _done

_done:
        ; copy the current nibble's ASCII value to a char in our template
        ; string
        mov bx, HEX_OUT

        ; print our template string
        call print_string

        ; pop all arguments
        popa

        ; return from subroutine
        ret

add_7:
        ; add 7 to our current nibble's ASCII value, in order to get letters
        add bh, 0x7

        ; add the current nibble's ASCII
        jmp add_character_hex

; our global template string. We'll replace the zero digits here with the
; actual nibble values from the hex input.
HEX_OUT:
        db '0x0000', 0
