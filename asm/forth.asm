; vim: :set ft=nasm:

[bits 16]

; Forth is a simple stack-based language.
;
; See
;
; - http://beza1e1.tuxen.de/articles/forth.html
; - https://github.com/nornagon/jonesforth/blob/master/jonesforth.S
;
forth:
  push bx
  push dx

  mov bx, data.forth_start_msg
  call io.puts
  mov bx, data.newline
  call io.print
  mov bx, data.forth_help0
  call io.puts
  mov bx, data.forth_help1
  call io.puts
  mov bx, data.newline
  call io.print
  mov bx, data.forth_prompt
  call io.print

.loop:
  ; clear the current line's memory (erase old line)
  mov bx, data.forth_input
  mov word [bx], 0

  ; set length to 0
  mov dx, 0

  call io.readline

  ; If we entered a blank line, start input over
  mov al, [data.forth_input]
  cmp al, 0
  je .noinput

  mov bx, data.newline
  call io.print

  mov bx, data.forth_len_msg
  call io.print
  call io.print_hex

  ; We did get user input, so print the new prompt for results
  mov bx, data.newline
  call io.print
  mov bx, data.forth_result_prompt
  call io.print

  ; TODO: more than just echo
  mov bx, data.forth_input
  call io.print

.noinput:
  mov bx, data.newline
  call io.print
  mov bx, data.forth_prompt
  call io.print
  jmp .loop
.done:
  mov bx, data.newline
  call io.print
  mov bx, data.forth_end_msg
  call io.print
  pop bx
  ret


data.forth_prompt:        db "? ", 0
data.forth_result_prompt: db "> ", 0
data.forth_input:         resb 25 ; characters of user input

data.forth_start_msg: db "[forth] Started forth...", 0
data.forth_help0:     db "Example:", 0
data.forth_help1:     db "  : hi CR .", 34, "Hello, World!", 34, ";", 0
data.forth_end_msg:   db "[forth] Exited forth.", 0

data.forth_len_msg:   db "length: ", 0
