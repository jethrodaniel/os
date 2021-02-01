; vim: :set ft=nasm:

[bits 16]

; Print (with a newline) the null-terminated string whose address is
; in `bx`.
;
puts_string:
  subroutine_start
  call print_string
  mov bx, newline
  call print_string
  subroutine_end

; Print the null-terminated string whose address is in `bx`.
;
print_string:
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
