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

  bios.read_char_into_al

  ; Exit if the enter key is pressed.
  ;
  cmp al, 13
  je .done

  bios.print_char_in_al

  jmp .loop
.done
  io.print_str data.newline
  io.print_str data.exit_msg

  subroutine_end

data.user_input:      db 10, 0
