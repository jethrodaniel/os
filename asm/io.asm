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


; Print the value of `dx` as a hex string.
;
io.print_hex:
  push si
  push bx
  push cx

  ; use si to keep track of the current char in our template string
  mov si, data.hex_template + 2

  ; count how many nibbles we've processed, stop at 4
  mov cx, 0

.next_character:
  ; increment the counter for each nibble
  inc cx

  ; isolate this nibble
  mov bx, dx
  and bx, 0xf000
  shr bx, 4

  ; add 0x30 to get the ASCII digit value
  add bh, 0x30

  ; If our hex digit was > 9, it'll be > 0x39, so add 7 to get
  ; ASCII letters
  cmp bh, 0x39
  jg .add_7

.add_character_hex:
  ; put the current nibble into our string template
  mov [si], bh

  ; increment our template string's char position
  inc si

  ; shift dx by 4 to start on the next nibble (to the right)
  shl dx, 4

  ; exit if we've processed all 4 nibbles, else process the next
  ; nibble
  cmp cx, 4
  jnz .next_character
  jmp .done

.done:
  ; copy the current nibble's ASCII value to a char in our template
  ; string
  mov bx, data.hex_template

  ; print our template string
  call io.print

  pop cx
  pop bx
  pop si
  ret

.add_7:
  ; add 7 to our current nibble's ASCII value, in order to get letters
  add bh, 0x7

  ; add the current nibble's ASCII
  jmp .add_character_hex

data.hex_template: db '0x0000', 0



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

  ; add this digit
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
