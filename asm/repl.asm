; vim: :set ft=nasm:

[bits 16]

; Start a read-eval print loop.
;
; This is a monitor program, which allows you to interact with
; memory cells directly.
;
; See
;
; - https://www.atariarchives.org/mlb/chapter3.php
; - https://www.youtube.com/watch?reload=9&v=Qn6TCXJmITM
;
repl:
  push bx
  push dx

  mov bx, data.repl_msg
  call io.puts
  mov bx, data.prompt
  call io.print

.loop:
  ; clear the current line's memory (erase old line)
  mov bx, data.input
  mov word [bx], 0

  ; set length to 0
  mov dx, 0

  call io.readline

  ; If we entered a blank line, start input over
  mov al, [data.input]
  cmp al, 0
  je .noinput

  ; If we entered `r`, show registers
  mov al, [data.input]
  cmp al, 114 ; r
  je .show_registers

  mov bx, data.newline
  call io.print

  ; tmp: input length: 0x000
  mov bx, data.len
  call io.print
  call io.print_hex

  ; We did get user input, so print the new prompt for results
  mov bx, data.newline
  call io.print
  mov bx, data.result_prompt
  call io.print

  ; We're expecting hex input, convert that string into a number
  mov bx, data.input
  call io.convert_hex_str_to_num
  call io.print_hex

.noinput:
  mov bx, data.newline
  call io.print
  mov bx, data.prompt
  call io.print
  jmp .loop
.show_registers:
  mov bx, data.newline
  call io.print

%macro print_reg 1
  push %1
  mov bx, data.reg_%1
  call io.print
  pop %1

  push %1
  mov dx, %1
  call io.print_hex
  mov bx, data.newline
  call io.print
  pop %1
%endmacro

  print_reg ax
  print_reg bx
  print_reg cx
  print_reg dx

  jmp .noinput
.done:
  mov bx, data.newline
  call io.print
  mov bx, data.exit_msg
  call io.print
  pop bx
  ret

data.len: db "len: ", 0
data.reg_ax: db "AX: ", 0
data.reg_bx: db "BX: ", 0
data.reg_cx: db "CX: ", 0
data.reg_dx: db "DX: ", 0
