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
  io.puts_str  data.repl_msg
  io.print_str data.prompt

.loop
  ; clear the current line's memory (erase old line)
  mov word [bx], 0

  ; read a line from the user
  call io._read_str

  ; if we just typed a number, print contents of that address
  ; io.print_str data.user_input
  ; call io._print_str

  ; If we entered a blank line, start input over
  mov ax, [bx]
  cmp ax, 0
  je .noinput

  ; We did get user input, so print the new prompt for results
  io.print_str data.newline
  io.print_str data.result_prompt

  call io.convert_hex_str_to_num
  ; mov dx, 0xbeef
  call io.print_hex

.noinput:
  io.print_str data.newline
  io.print_str data.prompt
  jmp .loop
.done
  io.print_str data.newline
  io.print_str data.exit_msg
  ret
