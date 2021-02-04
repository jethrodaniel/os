; vim: :set ft=nasm:

[bits 16]

; Print the null-terminated string whose address is in `bx`.
;
io.print:
  push ax
.print_char:
  ; Load the next byte from `bx` into `al` for printing
  mov al, [bx]

  ; Move to the next byte, i.e, the next ASCII character
  inc bx

  ; Done when we find the null terminator
  cmp al, 0
  je .done

  bios.print_char_in_al

  ; Repeat with the next byte
  jmp .print_char
.done:
  pop ax
  ret

; Print (with a newline) the null-terminated string whose address is
; in `bx`.
;
io.puts:
  call io.print
  push bx
  mov bx, data.newline
  call io.print
  pop bx
  ret

; Read (with echo) a \r-terminated string into `bx`, store
; length in `dx`.
;
io.readline:
  push ax
  mov dx, 0
.loop:
  bios.read_char_into_al

  ; if \r
  cmp al, 13
  je .done

  ; echo
  bios.print_char_in_al

  ; get next char, advance
  mov [bx], al
  inc bx

  ; increment length
  inc dx

  jmp .loop
.done:
  pop ax
  ret


; Print a base10 string in hex whose address is in `dx`.
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

; Convert hexadecimal string whose address is in `bx` into a number,
; store in `dx`.
;
io.convert_hex_str_to_num:
  push ax

  push bx   ; store original bx
  mov ax, 0 ; tmp
  mov dx, 0 ; sum
.next_char:
  ; Load the next byte from `bx` into `al`
  mov al, [bx]
  ; Move to the next byte, i.e, the next ASCII character
  inc bx

  ; We're done if `al` is `\0`
  cmp ax, 0
  je .done

  ; If `al` is `A-F`, then subtract an additional 7
  cmp al, 0x39
  jg .minus_7
.minus_7_ret:

  ; subtract 0x30 to get the numeric value from the ASCII value
  sub al, 0x30

  ; 0 - 0x30
  ; 1 - 0x31

  ; add that value to our sum
  xor ah, ah
  add dx, ax

  jmp .next_char
.minus_7:
  sub al, 0x7
  jmp .minus_7_ret
.done:
  pop bx ; restore original bx

  pop ax
  ret
