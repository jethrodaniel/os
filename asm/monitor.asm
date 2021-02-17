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

; 0xaa: ...
data.print: db ": ", 0
data.write: db ": ", 0

; Print memory contents of the address whose null-terminated
; string is located in `bx`.
;
monitor_print:
  push bx
  push dx

  inc bx            ; eat the `p`
  call io.atoi      ; place start address in `dx`
  call io.print_hex ; print start address

  push bx
  mov bx, data.print
  call io.print
  pop bx

  call io.atoi
  mov bx, dx
  mov dx, [bx]
  call io.print_hex
  bios.print_newline

  pop dx
  pop bx
  ret

; Write to memory starting at the address whose null-terminated
; string is located in `bx`.
;
monitor_write:
  push bx
  push dx

  inc bx            ; eat the `w`
  call io.atoi      ; place start address in `dx`
  call io.print_hex ; print start address

  ; todo: actually pass in data
  ;
  mov bx, dx
  mov [bx], byte 32   ; write value to start address
  bios.print_newline

  pop dx
  pop bx
  ret


; Execute a WORD whose null-terminated name string is located in
; address `bx`.
;
monitor_exec_word:
  push ax
  push bx
  push dx

  mov al, [bx]
  cmp al, 'p'
  jne .not_p
  call monitor_print

.not_p:

  mov al, [bx]
  cmp al, 'w'
  jne .not_w
  call monitor_write

.not_w:

  ; call number?
  ; cmp ax, 0
  ; je .err_not_a_number

.return:
  pop dx
  pop bx
  pop ax
  ret
.err_not_a_number:
  push bx
  mov bx, data.monitor_err_not_a_number_msg
  call io.puts
  pop bx
  jmp .return

data.monitor_err_not_a_number_msg: db "error: not a number", 0


; Execute a monitor program whose null-terminated string is
; located in address `bx`.
;
; The string is split by whitespace into words, each of which is
; executed by `monitor_exec_word`, as it's split.
;
monitor_exec:
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
  call monitor_exec_word
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


; Enter a monitor read-eval-print loop.
;
; Uses it's own input buffer.
;
monitor_repl:
  push bx
  push dx

  mov bx, data.monitor_start_msg
  call io.puts
  mov bx, data.monitor_prompt
  call io.print

.loop:
  mov bx, data.monitor_input ; erase line
  mov byte [bx], 0

  call io.readline

  ; If we entered a blank line, start input over
  mov al, [data.monitor_input]
  if_equal_jmp al, 0, .noinput ; \0

  bios.print_newline
  mov bx, data.monitor_input
  call monitor_exec

  jmp .continue
.noinput:
  bios.print_newline
.continue:
  mov bx, data.monitor_prompt
  call io.print
  jmp .loop


data.monitor_prompt: db "? ", 0
data.monitor_input:  resb 25 ; characters of user input
data.monitor_start_msg:
  db "monitor| Started monitor...", \
  13, 10, \
  13, 10, "Example:", \
  13, 10, "  p7c00", \
  13, 10, 0
