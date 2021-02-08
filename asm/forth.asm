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


; https://web.archive.org/web/20060201232627/http://dec.bournemouth.ac.uk/forth/forth.html
; http://www.bradrodriguez.com/papers/tcjassem.txt


; ```
; : hi cr ." Hi!" ;
; ```
;
; ```
; `:` - word defined as the address of the address interpreter
;
; +-------------------------------------------------------------+
; | link | 2 | hi | (:) | open | trxt | . | echo | close | exit |
; +-------------------------------------------------------------+
;   |      |  |     |
;   |      + name length  |-------------- body -----------------|
;   |         |     |
;   |         + name
;   |               |
;   + prev link     | code field address
;                   + (CFA)
;
; |------  head ----------|
; ```
;
;
;

forth:
  push bx
  push dx

  ; Startup messages
  mov bx, data.forth_start_msg
  call io.puts
  mov bx, data.forth_prompt
  call io.print

  ; Main loop.
  ;
  ; ```forth
  ;
  ; \ The forth keyboard interpreter, `quit` is started when
  ; \ forth boots.
  ; \
  ; : quit ( -- )
  ;   begin
  ;     reset     \ clear the stacks
  ;     query     \ wait for user input, or read input from disk
  ;     interpret \ find dictionary match, execute
  ;   again       \ loop
  ; ;
  ; ```
  ;
.loop:
  ; clear the current line's memory (erase old line)
  mov bx, data.forth_input
  ; todo: seperate subroutine to zero out a string
  mov dword [bx], 0 ; zero out first 4 bytes

  ; Read a line of user input
  call io.readline

  ; If we entered a blank line, start input over
  mov al, [data.forth_input]
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
  ; call number?

  call io.atoi
  call io.print_hex

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
