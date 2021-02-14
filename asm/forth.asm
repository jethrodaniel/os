; vim: :set ft=nasm:

[bits 16]


; Check if string in `bx` is a valid integer, if so, leave `1`
; in `ax`, else `0`.
;
number?:
  push ax
  push bx

  ; fail on empty string
  mov al, [bx] ; load character
  cmp al, 0    ; exit if at end of string
  je .return_false

.next_char:
  mov al, [bx] ; load character
  inc bx       ; move to next character

  cmp al, 0 ; exit if at end of string
  je .return_true

  cmp al, '9'
  jle .ge_zero

.return_false:
  pop bx
  pop ax
  mov ax, 0
  ret
.ge_zero:
  cmp al, '0'
  jge .next_char
.return_true:
  pop bx
  pop ax
  mov ax, 1
  ret


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

; http://www.retroprogramming.com/2012/04/itsy-forth-dictionary-and-inner.html

;%define link 0
;%define immediate 080h

;%macro head 4
;  %%link dw link
;  %define link %%link
;  %strlen %%count %1
;  db %3 + %%count,%1
;  xt_ %+ %2 dw %4
;%endmacro

;%macro primitive 2-3 0
;  head %1,%2,%3,$+2
;%endmacro

;; %macro colon 2-3 0
;;   head %1,%2,%3,docolon
;; %endmacro

;%macro constant 3
;  head %1,%2,0,doconst
;  val_ %+ %2 dw %3
;%endmacro

;; %macro variable 3
;;   head %1,%2,0,dovar
;;   val_ %+ %2 dw %3
;; %endmacro


;; sp - data stack pointer
;; bp - return stack pointer
;; si - instruction pointer
;; di - pointer to current XT (execution token)
;; bx - TOS (top of data stack)


;; Forth starts this on boot:
;;
;;   : quit ( -- ) begin reset query interpret again ;
;;
;quit:

;; Clear the stacks.
;;
;reset:

;; Read a line from user input or from disk.
;;
;query:


;; https://www.forth.com/starting-forth/1-forth-stacks-dictionary/

;; ( -- ) scan the input stream, lookup and execute each word
;;
;; Scan the input stream for whitespace-seperated words. For each word,
;; look it up in the dictionary.
;;
;; If present, call `execute`, then print `ok`.
;; If not present, call `number`
;;
;interpret:

;; Check if the current word is a number.
;;
;; If so, push it's number value onto the stack.
;; Otherwise, print an error message.
;;
;number:

;; ( -- ) execute the definition of the current word, echo `ok`
;;
;;
;execute:


;; https://wiki.c2.com/?ForthLanguage

;; Lookup the current word name in the dictionary
;find:


;; (x y -- z) calculate z=x+y then return z
;;
;word_plus:
;  db 0
;  db "+", 0
;word_plus_code:
;  pop bx
;  pop ax
;  add bx, ax


;; https://github.com/sayon/forthress/blob/master/src/words.inc

;%define _link 0

;; ```
;; native "+", plus
;;   pop ax
;;   add [sp], ax
;;   jmp next
;; ```
;;
;; 1 - word name
;; 2 - word label name
;; 3 - flags
;;
;%macro native 3
;  wh_ %+ %2:             ; wh_plus:               ; header label
;    db _link             ;  db _link              ;  link
;    db %1, 0             ;  db "+", 0             ;  word name
;    db %3                ;  db 0                  ;  flags

;  %define _link wh_%+ %2 ; %define _link, wh_plus ; update link var
;  xt_ %+ %2:             ; xt_plus:               ; CFA label
;    db i_ %+ %2          ;  db i_plus             ;   address of code
;    i_ %+ %2:            ;  i_plus:               ;   executable code
;%endmacro

;%macro native 2
;  native %1, %2, 0
;%endmacro


;; %define pc
;; %define w r14
;; %define rstack bp

;; ( y x -- [ x + y ] )
;native "+", plus
;  pop ax
;  add [sp], ah
;  jmp next

;state: resw 1

;; return stack end-----;
;resw 50                ;
;rstack_start: resw 1   ;
;; return stack start---;



;; Initialization routine.
;;
;native "init", init
;  mov word [state], 0
;  mov rstack, rstack_start
;  mov pc, interpreter_stub
;  cmp qword [stack_base], 0
;  je  .first
;  mov rsp, [stack_base]
;  jmp next
;  .first:
;  mov [stack_base], rsp
;  jmp next



;next: ; inner interpreter, fetches next word to execute
;  mov w, pc
;  add pc, 8
;  mov w, [w]
;  jmp [w]

;boot:
;  jmp i_init


%macro NEXT 0
  mov ax, [si]
  add si, 4
  jmp [ax]
%endmacro

%macro PUSHRSP 1
  lea bp, [bp - 4]  ; push reg onto return stack
  mov [bp], %1
%endmacro

%macro PUSHRSP 1
  mov %1, [bp]
  lea bp, [bp + 4]  ; push top of return stack to reg
%endmacro



; Execute a WORD whose null-terminated name string is located in
; address `bx`.
;
forth_exec_word:
  push ax
  push bx
  push dx

  ; call find?
  ; mov dx, ax
  ; call io.print_hex
  ; bios.print_newline

  call number?
  cmp ax, 0
  je .err_not_a_number

  call io.atoi
  call io.print_hex
  bios.print_newline

  mov dx, ax
  call io.print_hex
  bios.print_newline

  ; call io.atoi
  ; call io.puts

.return:
  pop dx
  pop bx
  pop ax
  ret
.err_not_a_number:
  push bx
  mov bx, data.forth_err_not_a_number_msg
  call io.puts
  pop bx
  jmp .return

data.forth_err_not_a_number_msg: db "error: not a number", 0


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
