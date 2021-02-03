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
  subroutine_start

  io.puts_str  data.repl_msg
  io.print_str data.prompt

.loop
  call io._read_str
  io.print_str data.newline
  io.print_str data.result_prompt

  ; call io.convert_hex_str_to_num
  ; call io.print_hex

  ; if we just typed a number, print contents of that address
  ; cmp al,
  io.print_str data.user_input

  io.print_str data.newline
  io.print_str data.prompt
  jmp .loop
.done
  io.print_str data.newline
  io.print_str data.exit_msg

  subroutine_end
