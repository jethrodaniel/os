; vim: :set ft=nasm:

[bits 16]


; BIOS call to read an ASCII character into `al`, without echo.
;
%macro bios.read_char_into_al 0
  mov ah, 00h
  int 16h
%endmacro


; BIOS call to print the ASCII character in `al`.
;
%macro bios.print_char_in_al 0
  mov ah, 0eh
  int 0x10
%endmacro


; Print a newline, then a carriage return.
;
%macro bios.print_newline 0
  push ax
  mov al, 10 ; \n
  bios.print_char_in_al
  mov al, 13 ; \r
  bios.print_char_in_al
  pop ax
%endmacro


; Print the null-terminated string whose address is in `bx`.
;
io.print:
  push ax
.print_char:
  mov al, [bx] ; load character
  inc bx       ; move to next character

  cmp al, 0    ; exit if at end of string
  je .done

  bios.print_char_in_al

  jmp .print_char ; print next character
.done:
  pop ax
  ret


; Print the null-terminated string whose address is in `bx`, then
; a newline.
;
io.puts:
  call io.print
  bios.print_newline
  ret


; Read a \r-terminated string into `bx`, echo as typed.
;
io.readline:
  push ax
.loop:
  bios.read_char_into_al

  mov [bx], al ; load next character
  inc bx       ; move to next character

  bios.print_char_in_al

  cmp al, 13  ; exit if \r
  jne .loop
.done:
  pop ax
  ret


; Print the value of `dx` as a hexadecimal string.
;
io.print_hex:
  push ax ; current digit
  push bx ; current sum
  push cx ; digit/character count

  mov bx, dx ; sum is initially our `dx` value
  xor cx, cx ; count = 0

.loop:
  mov ax, bx ; digit = sum % 16
  and ax, 0xf
  shr bx, 4  ; sum /= 16;

  add al, '0' ; convert to ASCII
  cmp al, '9' ; convert 9+ into A-F
  jg .convert_to_letter
.after_convert_to_letter:

  push ax ; push character
  inc cx

  cmp bx, 0 ; if on the last digit
  jg .loop

.done:
  mov al, '0'
  bios.print_char_in_al
  mov al, 'x'
  bios.print_char_in_al

.pop_char:
  cmp cx, 0 ; if we've printed all the digits
  je .return

  pop ax ; print next digit
  dec cx
  bios.print_char_in_al

  jmp .pop_char

.return:
  pop cx
  pop bx
  pop ax
  ret
.convert_to_letter:
  add al, 0x7 ; convert 0-9+ into A-F
  add al, 32  ; use lowercase letters
  jmp .after_convert_to_letter
