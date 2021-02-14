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

; http://www.retroprogramming.com/2012/04/itsy-forth-dictionary-and-inner.html

%define link 0
%define immediate 080h

%macro head 4
  %%link dw link
  %define link %%link
  %strlen %%count %1
  db %3 + %%count,%1
  xt_ %+ %2 dw %4
%endmacro

%macro primitive 2-3 0
  head %1,%2,%3,$+2
%endmacro

; %macro colon 2-3 0
;   head %1,%2,%3,docolon
; %endmacro

%macro constant 3
  head %1,%2,0,doconst
  val_ %+ %2 dw %3
%endmacro

; %macro variable 3
;   head %1,%2,0,dovar
;   val_ %+ %2 dw %3
; %endmacro


; sp - data stack pointer
; bp - return stack pointer
; si - instruction pointer
; di - pointer to current XT (execution token)
; bx - TOS (top of data stack)

; `:`, the XT to enter a Forth word.
;
docolon:
  dec bp
  dec bp
  mov word [bp], si ; save IP on the return stack
  lea si, [di + 2]  ; move IP to the word being entered


; Return from a primitive word, then call the next XT.
;
next:
  lodsw
  xchg di, ax
  jmp word [di]


; Return from a compiled Forth word.
;
; ( -- ) return from the current word
;
primitive 'exit', exit
  mov si, word [bp] ; recover IP from the return stack
  inc bp
  inc bp
  jmp next


; (addr -- x) read x from addr
;
primitive '@', fetch
  mov bx, word [bx]
  jmp next


; (x addr -- ) store x at addr
;
primitive '!',store
  pop word [bx]
  pop bx
  jmp next


; (addr -- char) read char from addr
;
primitive 'c@', c_fetch
  mov bl, byte [bx]
  mov bh, 0
  jmp next


; (x -- ) remove x from the stack
;
primitive 'drop', drop
  pop bx
  jmp next


; (x -- x x) add a copy of x to the stack
;
primitive 'dup', dupe
  push bx
  jmp next


; (x y -- y x) exchange x and y
primitive 'swap', swap
  pop ax
  push bx
  xchg ax, bx
  jmp next


; (x y z -- y z x) rotate x, y, and z
;
primitive 'rot', rote
  pop dx
  pop ax
  push dx
  push bx
  xchg ax,bx
  jmp next

; (x -- ) jump if x is zero
;
primitive '0branch', zero_branch
  lodsw
  test bx, bx
  jne zerob_z
  xchg ax, si
zerob_z:
  pop bx
  jmp next


; ( -- ) unconditional jump
;
primitive 'branch', branch
  mov si, word [si]
  jmp next


; (xt -- ) call the word at xt
;
primitive 'execute', execute
  mov di, bx
  pop bx
  jmp word [di]


; Execution token for constants
;
doconst:
  push bx
  mov bx, word [di + 2]
  jmp next


; Execution token for variables
dovar:
  push bx
  lea bx, [di + 2]
  jmp next


; ( -- addr) address of the input buffer
;
constant 'tib', t_i_b, 32768


; ( -- n) number of characters in the input buffer
;
variable '#tib', number_t_i_b, 0


;  ( -- c) next character in input buffer
variable '>in', to_in, 0


; ( -- bool) true = compiling, false = interpreting
;
variable 'state', state, 0


; ( -- addr) first free cell in the dictionary
;
variable 'dp', dp, freemem


; ( -- base) number base
;
variable 'base', base, 10


; ( -- addr) the last word to be defined
;
variable 'last', last, final


; ( x -- ) compile x to the current definition

primitive ',', comma
  mov ax, word [val_dp]
  xchg ax, bx
  add word [val_dp], 2
  mov word [bx], ax
  pop bx
  jmp next


;  (char -- ) compile char to the current definition
;
primitive 'c, ', c_comma
  mov ax, word [val_dp]
  xchg ax, bx
  inc word [val_dp]
  mov byte [bx], al
  pop bx
  jmp next


; ( -- ) push the value in the cell straight after lit
;
primitive 'lit', lit
  push bx
  lodsw
  xchg ax, bx
  jmp next


; (x y -- z) calculate z=x+y then return z
;
primitive '+', plus
  pop ax
  add bx, ax
  jmp next


; (x y -- flag) return true if x=y
;
primitive '=', equals
  pop ax
  sub bx, ax
  sub bx, 1
  sbb bx, bx
  jmp next


; (addr len -- len2) read a string from the terminal
;
primitive 'accept', accept
  pop di
  xor cx, cx
acceptl:
  call getchar
  cmp al, 8
  jne acceptn
  jcxz acceptb
  call outchar
  mov al, ' '
  call outchar
  mov al, 8
  call outchar
  dec cx
  dec di
  jmp acceptl
acceptn:
  cmp al, 13
  je acceptz
  cmp cx, bx
  jne accepts
acceptb:
  mov al, 7
  call outchar
  jmp acceptl
accepts:
  stosb
  inc cx
  call outchar
  jmp acceptl
acceptz:
  jcxz acceptb
  mov al, 13
  call outchar
  mov al, 10
  call outchar
  mov bx, cx
  jmp next
getchar:
  mov ah, 7
  int 021h
  mov ah, 0
  ret

outchar:
  xchg ax, dx
  mov ah, 2
  int 021h
  ret

primitive 'word', word
   mov di, word [val_dp]
   push di
   mov dx, bx
   mov bx, word [val_t_i_b]
   mov cx, bx
   add bx, word [val_to_in]
   add cx, word [val_number_t_i_b]
wordf:
  cmp cx, bx
  je wordz
  mov al, byte [bx]
  inc bx
  cmp al, dl
  je wordf
wordc:
  inc di
   mov byte [di], al
   cmp cx, bx
   je wordz
   mov al, byte [bx]
   inc bx
   cmp al, dl
   jne wordc
wordz:
  mov byte [di+1], 32
  mov ax, word [val_dp]
  xchg ax, di
  sub ax, di
  mov byte [di], al
  sub bx, word [val_t_i_b]
  mov word [val_to_in], bx
  pop bx
  jmp next

primitive 'emit', emit
  xchg ax, bx
  call outchar
  pop bx
  jmp next




; -------------


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
