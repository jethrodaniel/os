; vim: :set ft=nasm:

[bits 16]

; Forth is a simple stack-based language.
;
; References
;
; - http://beza1e1.tuxen.de/articles/forth.html
; - https://github.com/nornagon/jonesforth/blob/master/jonesforth.S
;
; - John Metcalf's (http://www.retroprogramming.com/) minimal forth system:
;   - http://www.retroprogramming.com/2012/03/itsy-forth-1k-tiny-compiler.html
;   - http://www.retroprogramming.com/2012/04/itsy-forth-dictionary-and-inner.html
;   - http://www.retroprogramming.com/2012/04/itsy-forth-primitives.html
;   - http://www.retroprogramming.com/2012/06/itsy-forth-compiler.html
;   - http://www.retroprogramming.com/2012/09/itsy-documenting-bit-twiddling-voodoo.html
;   - https://github.com/phf/itsy-forth/blob/master/msdos/itsy.asm
;   - https://github.com/phf/itsy-forth/blob/master/msdos/macros.asm
;
;
forth:
  push bx
  push dx

  ; Startup messages
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

  ; Main loop.
  ;
  ; - get input
  ; - process each "word" in input
  ;   - look for that word in the dictionary
  ;     - if we found it:
  ;       - ...
  ;     - otherwise, we
  ;       - check if it's a number
  ;       - if not, we error "unknown word"
  ;
.loop:
  ; clear the current line's memory (erase old line)
  mov bx, data.forth_input
  mov word [bx], 0

  ; Read a line of user input
  call io.readline

  ; If we entered a blank line, start input over
  mov al, [data.forth_input]
  cmp al, 0
  je .noinput

  mov bx, data.newline
  call io.print

  ; TEMP: print out length of input
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
