; vim: :set ft=nasm:

[bits 16]

; Print (with a newline) the null-terminated string whose address is
; in `bx`.
;
io._puts_str:
  subroutine_start
  call io._print_str
  mov bx, data.newline
  call io._print_str
  subroutine_end

; Print the null-terminated string whose address is in `bx`.
;
io._print_str:
  subroutine_start

.print_char:
  ; Load the next byte from `bx` into `al` for printing
  mov al, [bx]

  ; Move to the next byte, i.e, the next ASCII character
  inc bx

  ; If `al` is `0`, i.e, `\0` or the null byte, then we're done
  cmp al, 0
  je .done

  bios.print_char_in_al

  ; Repeat with the next byte
  jmp .print_char

.done:
  subroutine_end


; Print a number in hexadecimal whose address is in `dx`.
;
; used as an answer here: https://stackoverflow.com/a/27686875/7132678
;
io.print_hex:
  subroutine_start

  ; use si to keep track of the current char in our template string mov si, HEX_OUT + 2
  mov si, HEX_OUT + 2

  ; start a counter of how many nibbles we've processed, stop at 4
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
  mov bx, HEX_OUT

  ; print our template string
  call io._print_str

  subroutine_end

.add_7:
  ; add 7 to our current nibble's ASCII value, in order to get letters
  add bh, 0x7

  ; add the current nibble's ASCII
  jmp .add_character_hex


; read a \r-terminated string into memory, store address in `bx`.
;
io._read_str:
  push ax
  mov bx, data.user_input
.loop
  bios.read_char_into_al
  cmp al, 13
  je .done

  bios.print_char_in_al

  mov [bx], al
  inc bx
  jmp .loop
.done
  mov bx, data.user_input
  ; io.print_str data.newline
  ; io.print_str data.user_input
  ; subroutine_end
  pop ax
  ret

; Only 25 characters of user input
data.user_input: resb 25

; our global template string. We'll replace the zero digits here with the
; actual nibble values from the hex input.
HEX_OUT:
  db '0x0000', 0
