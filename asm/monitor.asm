; vim: :set ft=nasm:

[bits 16]

; A monitor program, which allows you to interact with
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

  mov bx, data.monitor_start_msg
  call io.puts
  mov bx, data.newline
  call io.print
  mov bx, data.monitor_help0
  call io.puts
  mov bx, data.monitor_help1
  call io.puts
  mov bx, data.monitor_help2
  call io.puts
  mov bx, data.newline
  call io.print
  mov bx, data.monitor_prompt
  call io.print

.loop:
  ; clear the current line's memory (erase old line)
  mov bx, data.monitor_input
  mov word [bx], 0

  ; set length to 0
  mov dx, 0

  call io.readline

  ; If we entered a blank line, start input over
  mov al, [data.monitor_input]
  cmp al, 0
  je .noinput

  ; If we entered `R/r`, show registers
  mov al, [data.monitor_input]
  cmp al, 114 ; r
  je .show_registers
  cmp al, 82 ; R
  je .show_registers

  mov bx, data.newline
  call io.print

  mov bx, data.monitor_len_msg
  call io.print
  call io.print_hex

  ; We did get user input, so print the new prompt for results
  mov bx, data.newline
  call io.print
  mov bx, data.monitor_result_prompt
  call io.print

  ; We're expecting hex input, convert that string into a number
  mov bx, data.monitor_input
  call io.convert_hex_str_to_num
  call io.print_hex

.noinput:
  mov bx, data.newline
  call io.print
  mov bx, data.monitor_prompt
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
  mov bx, data.monitor_end_msg
  call io.print
  pop bx
  ret


data.monitor_prompt:        db "? ", 0
data.monitor_result_prompt: db "=> ", 0
data.monitor_input:         resb 25 ; characters of user input

data.monitor_start_msg: db "[stage1] Started monitor...", 0
data.monitor_help0:     db "Help:", 0
data.monitor_help1:     db "<n>  show value at address <n>", 0
data.monitor_help2:     db "r    show registers", 0
data.monitor_end_msg:   db "[stage1] Exited monitor.", 0

data.monitor_len_msg: db "length: ", 0
data.reg_ax: db "AX: ", 0
data.reg_bx: db "BX: ", 0
data.reg_cx: db "CX: ", 0
data.reg_dx: db "DX: ", 0
