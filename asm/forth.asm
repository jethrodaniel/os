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


; Execute a WORD whose null-terminated name string is located in
; address `bx`.
;
forth_exec_word:
  push bx
  push dx

  call io.atoi
  call io.puts

  call io.print_hex
  bios.print_newline

  pop dx
  pop bx
  ret


; Execute a forth program whose null-terminated string is
; located in address `bx`.
;
; The string is split by whitespace into words, each of which is
; executed by `forth_exec_word`, as it's split.
;
forth_exec:
  push bx
  push cx ; start of current word

  call io.skip_whitespace
.next_word:
  mov cx, bx ; cx = string start address

.next_char:
  mov al, [bx] ; ax = <this char>

  ; exit if at end of string
  if_equal_jmp al, 0, .return ; \0

  if_equal_jmp al, 9,  .endword ; \t
  if_equal_jmp al, 10, .endword ; \n
  if_equal_jmp al, 13, .endword ; \r
  if_equal_jmp al, 32, .endword ; space

  inc bx       ; bx = <next char>
  jmp .next_char

.endword:
  mov byte [bx], 0 ; replace whitespace with null byte

  ; execute word
  push bx
  mov bx, cx
  call forth_exec_word
  pop bx

.skip_whitespace:
  inc bx     ; bx = <next char>
  mov cx, bx ; update start of word match
  call io.skip_whitespace
  if_equal_jmp al, 0, .return ; \0
  jmp .next_word
.return:
  pop bx
  pop cx
  ret


; Enter a forth read-eval-print loop.
;
; Uses it's own input buffer.
;
forth_repl:
  push bx
  push dx

  mov bx, data.forth_start_msg
  call io.puts
  mov bx, data.forth_prompt
  call io.print

.loop:
  mov bx, data.forth_input ; erase line
  mov byte [bx], 0

  call io.readline

  ; If we entered a blank line, start input over
  mov al, [data.forth_input]
  if_equal_jmp al, 0, .noinput ; \0

  bios.print_newline
  mov bx, data.forth_input
  call forth_exec

  jmp .continue
.noinput:
  bios.print_newline
.continue:
  mov bx, data.forth_prompt
  call io.print
  jmp .loop


data.forth_prompt: db "? ", 0
data.forth_input:  resb 25 ; characters of user input
data.forth_start_msg:
  db "forth| Started forth...", \
  13, 10, \
  13, 10, "Example:", \
  13, 10, "  : hi cr .", 34, 32, "Hello, World!", 34, " ;", \
  13, 10, 0
