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

  call io.skip_whitespace      ; skip leading whitespace
  mov al, [bx]                 ; check first character
  if_equal_jmp al, 0, .err_eof ; \0 (end of program)

  call number?       ; expect a number
  cmp ax, 0
  je .err_not_number

  ; mov bx, dtest
  call io.atoi      ; place start address in `dx`
  call io.print_hex ; print start address

  push bx
  mov bx, data.print
  call io.print
  pop bx

  mov bx, dx
  mov dx, [bx]
  call io.print_hex
  bios.print_newline
.return:
  pop dx
  pop bx
  ret
.err_not_number
  mov bx, data.err_not_number_msg
  call io.puts
  jmp .return
.err_eof
  mov bx, data.err_eof_msg
  call io.puts
  jmp .return

data.err_not_number_msg: db "addresses must be numbers", 0
data.err_eof_msg:        db "expected an address, got end of input", 0


; Write to memory starting at the address whose null-terminated
; string is located in `bx`.
;
monitor_write:
  push bx
  push dx

  ; ; inc bx            ; eat the `w`
  call io.atoi      ; place start address in `dx`
  call io.print_hex ; print start address

  ; todo: actually pass in data
  ;
  mov bx, dx
  mov [bx], word 43828   ; write value to start address
  bios.print_newline

  pop dx
  pop bx
  ret


; Execute a monitor program whose null-terminated string is
; located in address `bx`.
;
; ```
; p42        print contents of address `0x42`
; w42 1 2    write bytes `0x1` and `0x2` starting at address `0x42`
; g42        `jmp` to address `0x42`
; ```
;
monitor_exec:
  push ax
  push bx
  push cx ; start of current word

  call io.skip_whitespace     ; skip leading whitespace
  mov al, [bx]                ; check first character
  if_equal_jmp al, 0, .return ; \0 (end of program)

  cmp al, 'p'
  jne .notp
  inc bx ; eat the `p`
  call monitor_print
  .notp:
  ; if_equal_call al, 'p', monitor_print ;

  cmp al, 'w'
  jne .notw
  inc bx ; eat the `w`
  call monitor_write
  .notw:
  ; if_equal_call al, 'w', monitor_write ;

.return:
  pop cx
  pop bx
  pop ax
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
  mov word [bx], 0

  call io.readline

  ; ; push bx
  ; ;   bios.print_newline
  ; ;   mov bx, data.monitor_input
  ; ;   call io.puts
  ; ; pop bx

  ; push bx
  ; push dx

  ;   ; mov bx, dtest
  ;   ; mov byte [bx + 1], '1'
  ;   ; mov bx, dtest
  ;   ; mov bx, data.monitor_input
  ;   call io.atoi
  ;   bios.print_newline
  ;   call io.print_hex
  ;   bios.print_newline
  ; pop dx
  ; pop bx

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
; data.monitor_input:  resb 25 ; characters of user input
data.monitor_input:  db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
data.monitor_start_msg:
  db "monitor| Started monitor...", \
  13, 10, \
  13, 10, "Example:", \
  13, 10, "  p31744", \
  13, 10, 0
