; vim: :set ft=nasm:

[bits 16]


; Convert decimal string in `bx` into an integer in `dx`.
;
io.atoi:
  push ax
  push bx

  xor dx, dx ; dx = 0
.next_char:
  mov al, [bx] ; load character
  inc bx       ; move to next character

  cmp al, 0 ; exit if at end of string
  je .return

  sub al, '0' ; convert ASCII to digit value

  imul dx, dx, 10 ; increase prev digit by factor of the base
  add dx, ax      ; add this digit
  jmp .next_char  ; get next character ('0' if end of input)
.return:
  pop bx
  pop ax
  ret
