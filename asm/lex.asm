; vim: :set ft=nasm:

[bits 16]


; Skip whitespace in a null-terminated string whose current
; character's address is located in `bx`.
;
io.skip_whitespace:
  push ax
.load:
  mov al, [bx] ; ax = <this char>
.eof?:
  if_equal_jmp al, 0,  .return ; \0
.whitespace?:
  if_equal_jmp al, 9,  .next ; \t
  if_equal_jmp al, 10, .next ; \n
  if_equal_jmp al, 13, .next ; \r
  if_equal_jmp al, 32, .next ; space
  jmp .return
.next:
  inc bx ; bx = <next char>
  jmp .load
.return:
  pop ax
  ret


; Skip non-whitespace in a null-terminated string whose current
; character's address is located in `bx`.
;
io.skip_non_whitespace:
  push ax
.load:
  mov al, [bx] ; ax = <this char>
.eof?:
  if_equal_jmp al, 0,  .return ; \0
.whitespace?:
  if_equal_jmp al, 9,  .return ; \t
  if_equal_jmp al, 10, .return ; \n
  if_equal_jmp al, 13, .return ; \r
  if_equal_jmp al, 32, .return ; space
.next:
  inc bx ; bx = <next char>
  jmp .load
.return:
  pop ax
  ret
