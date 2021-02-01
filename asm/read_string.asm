; vim: :set ft=nasm:

[bits 16]

; BIOS call to read a character.
;
; `al` will contain the ASCII value after the keypress.
;
bios.read_char_into_al:
  mov ah, 00h
  int 16h

bios.print_char_in_al:
  int 0x10

; read_char:
