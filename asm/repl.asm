; vim: :set ft=nasm:

[bits 16]

; Start a read-eval print loop.
;
; This is a monitor program, which allows you to interact with
; memory ells directly.
;
; See
;
; - https://www.atariarchives.org/mlb/chapter3.php
;
repl:
  subroutine_start

  io.puts_str  data.repl_msg
  io.print_str data.prompt

.loop
  ; mov dx, 0x4321
  ; call io.print_hex

  call io._read_str
  mov cx, bx
  io.print_str data.newline
  io.print_str data.result_prompt
  mov bx, cx
  call io._puts_str

  io.print_str data.prompt
  jmp .loop
.done
  io.print_str data.newline
  io.print_str data.exit_msg

  subroutine_end
