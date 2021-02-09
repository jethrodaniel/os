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
;----------------

; Execute a forth program whose null-terminated string is
; located in address `bx`.
;
forth_exec:
  ; debug: hex: ...
  ; mov bx, data.hex_result_msg
  ; call io.print
  ; pop bx
  ; push bx

  ; for now, just print hex value of string, assuming its a number
  call io.atoi
  call io.print_hex

  ret


; Enter a forth read-eval-print loop.
;
forth_repl:
  push bx
  push dx

  mov bx, data.forth_start_msg
  call io.puts
  mov bx, data.forth_prompt
  call io.print

.loop:
  ; clear the current line's memory (erase old line)
  mov bx, data.forth_input
  ; todo: separate subroutine to zero out a string
  mov dword [bx], 0 ; zero out first 4 bytes

  ; Read a line of user input
  call io.readline

  ; If we entered a blank line, start input over
  mov al, [data.forth_input]
  cmp al, 0
  je .noinput

  mov bx, data.newline
  call io.print

  mov bx, data.forth_input
  call forth_exec

.noinput:
  mov bx, data.newline
  call io.print
  mov bx, data.forth_prompt
  call io.print
  jmp .loop

data.forth_prompt:    db "? ", 0
data.forth_input:     resb 25 ; characters of user input
data.forth_start_msg:
  db "forth| Started forth...", \
  13, 10, \
  13, 10, "Example:", \
  13, 10, "  : hi cr .", 34, 32, "Hello, World!", 34, " ;", \
  13, 10, 0

; tmp
data.hex_result_msg:  db "hex: ", 0
