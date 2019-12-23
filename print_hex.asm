; vim: :set ft=nasm:

[BITS 16]

; subroutine to print a hex number.
;
; adapted from:
; - https://stackoverflow.com/a/27686875/7132678
; - https://config9.com/linux/how-to-print-a-number-in-assembly-nasm/
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
; this works like so:
;
; - the hex digit to print is in dx
; - we set si to have the current digit in the global string
;  - set bx to matc

;
; to print the first hex digit, we need to isolate the leftmost 4 bits
; of the input's 2 bytes.
;
;   0xa31f = 0xf * 16^0 + 0x1 * 16^1 + 3 * 16^2 + 0xa * 16^3
;
; first digit:
;
;  - get that 'a' at the end of a string
;
;  0xa31f >> 3 => 0x000a
;
; then we & it by 0xf to isolate it from the rest
;
; to get the ASCII code of this digit, we need to convert it to its
; ASCII value.
;
; if it's <= 9, then we can just add `0`'s ASCII (0x30), else we need to
; add `a`'s ASCII (0x39).
;
print_hex:
        ; push all registers onto the stack
        pusha

        ; start with the largest digit
        ;
        ; 0x 0 000
        ;   | |
        ;
        mov si, HEX_OUT + 2

next_character:
        ; move the current char to bx
        mov bx, dx

        ; 0x1fb6
        ; 0001111110110110
        ;
        ;    &
        ;
        ; 0xf000
        ; 1111000000000000
        ;
        ; => 1000000000000 (0x1000)
        and bx, 0xf000

        ; => 0000000100000000 (0x100)
        shr bx, 4

        ; Add a '0' to this string.
        ; 0x30, '0'
        add bh, 0x30

        ; 0x39
        ; 111001
        cmp bh, 0x39
        jg add_7

add_character_hex:
  mov al, bh
  mov [si], bh
  inc si
  shl dx, 4
  or dx, dx
  jnz next_character
  mov bx, HEX_OUT
  call print_string
  popa
  ret

add_7:
  add bh, 0x7
  jmp add_character_hex

HEX_OUT:
  db '0x0000', 0
