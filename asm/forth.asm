; vim: :set ft=nasm:

[bits 16]

;-----------------
; Forth is a simple stack-based language.
;
; See:
;
; - [JonesForth](https://github.com/nornagon/jonesforth/blob/master/jonesforth.S)
; - [John Metcalf's Itsy FORTH](https://github.com/phf/itsy-forth/blob/master/msdos/itsy.asm)
; - [And So Forth](https://thebeez.home.xs4all.nl/ForthPrimer/Forth_primer.html)
; - [Forth: An underview](https://web.archive.org/web/20060201232627/http://dec.bournemouth.ac.uk/forth/forth.html)
; - [Build Your Own (Cross-) Assembler....in Forth](http://www.bradrodriguez.com/papers/tcjassem.txt)
;
forth:
  push bx
  push dx

  mov bx, data.forth_start_msg
  call io.puts
  mov bx, data.forth_prompt
  call io.print

  ; Main loop:
  ;
  ; 1. Get next word, i.e, read a token until a space or end of input (\0)
  ; 2. Lookup word in dictionary
  ;   - If we found a match, execute the word
  ;   - If we didn't find a match, attempt to parse as a number
  ;   - Otherwise, complain about a missing word
  ;
.loop:
  ; clear the current line's memory (erase old line)
  mov bx, data.forth_input
  ; todo: separate subroutine to zero out a string
  mov dword [bx], 0 ; zero out first 4 bytes

  ; Read a line of user input
  call io.readline
  ; mov bx, data.test
  ; call io.print

  ; If we entered a blank line, start input over
  mov al, [data.forth_input]
  ; mov al, [data.test]
  cmp al, 0
  je .noinput

  ; We did get user input, so print the new prompt for results
  mov bx, data.newline
  call io.print

  ; hex: ...
  mov bx, data.hex_result_msg
  call io.print

  ; Word? Look it up and execute
  ; Number? push number on stack
  ; Otherwise, error.

  mov bx, data.forth_input
  ; mov bx, data.test
  ; call number?

  call io.atoi
  call io.print_hex

  mov bx, data.newline
  call io.print
  mov bx, data.forth_input
  call io.print

.noinput:
  mov bx, data.newline
  call io.print
  mov bx, data.forth_prompt
  call io.print
  jmp .loop

data.forth_prompt:        db "? ", 0
data.forth_input:         resb 25 ; characters of user input

data.forth_start_msg:
  db "forth| Started forth...", \
  13, 10, \
  13, 10, "Example:", \
  13, 10, "  : hi cr .", 34, 32, "Hello, World!", 34, " ;", \
  13, 10, 0
data.hex_result_msg:  db "hex: ", 0
; data.test: db "10", 0
data.test: incbin "hi.fs"
