; vim: :set ft=nasm:

[bits 16]

;-----------------
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
; - "And So Forth", by J.L Bezemer (2001)
;   - https://thebeez.home.xs4all.nl/ForthPrimer/Forth_primer.html
;

; https://raw.githubusercontent.com/phf/itsy-forth/master/msdos/macros.asm

; %define link 0
; %define immediate 0x080

; %macro head
;   %%link dw link
;   %define link %%link
;   %strlen %%count %1
;   db %3 + %%count,%1
;   xt_ %+ %2 dw %4
; %endmacro

; %macro primitive 2-3 0
;   head %1,%2,%3,$+2
; %endmacro

; %macro colon 2-3 0
;   head %1,%2,%3,docolon
; %endmacro

; %macro constant 3
;   head %1,%2,0,doconst
;   val_ %+ %2 dw %3
; %endmacro

; %macro variable 3
;   head %1,%2,0,dovar
;   val_ %+ %2 dw %3
; %endmacro

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

  ; mov bx, data.newline
  ; call io.print
  ; ; TEMP: print out length of input
  ; mov bx, data.forth_len_msg
  ; call io.print
  ; call io.print_hex

  ; We did get user input, so print the new prompt for results
  mov bx, data.newline
  call io.print

  ; Word? Look it up and execute
  ; Number? push number on stack
  ; Otherwise, error.

  mov bx, data.forth_input
  ; call number?

  ; BUG:
  ;   works for 0-9, but when you enter a larger digit, something's
  ;   getting borked.
  ;
  ;   0 -> 0
  ;   9 -> 9
  ;   10 -> A
  ;   123 -> 7b
  ;   10 -> 67 ? what?
  ;
  call io.atoi

  call io.print_hex
  mov bx, data.hex_template

.noinput:
  mov bx, data.newline
  call io.print
  mov bx, data.forth_prompt
  call io.print
  jmp .loop
.done:
  mov bx, data.newline
  call io.print
  mov bx, data.forth_exit_msg
  call io.print
  pop bx
  ret


data.forth_prompt:        db "? ", 0
data.forth_input:         resb 25 ; characters of user input

data.forth_start_msg: db "forth| Started forth...", 0
data.forth_exit_msg:  db "forth| Exited forth.", 0
data.forth_help0:     db "Example:", 0
data.forth_help1:     db "  : hi cr .", 34, 32, "Hello, World!", 34, " ;", 0

data.forth_len_msg:   db "length: ", 0


; Convert string in `bx` into an integer in `dx`.
;
io.atoi:
  push ax
  push bx

  xor dx, dx ; dx = 0
.next_character:
  xor ah, ah
  mov al, [bx] ; ax = <this char>
  inc bx       ; bx = <next char>

  ; exit if at end of string
  cmp al, 0
  je .leave

  ; subtract 0x30 to get the ASCII digit value
  sub al, '0'

  ; increase previous digit by a factor of the base
  imul dx, dx, 10

  ;add this digit
  add dx, ax

  ; jg .error_not_number

  ; get next character (may be '0' if end of input)
  jmp .next_character
.leave:
  pop bx
  pop ax
  ret
.error_not_number:
  mov bx, data.error_not_number_msg
  call io.print
  xor dx, dx ; dx = 0
  jmp .leave
data.error_not_number_msg:
  db " is not a number", 0
