; vim: :set ft=nasm:

[bits 16]


; ```
; if_equal_call al, 'p', monitor_print
; ```
;
%macro if_equal_jmp 3
  cmp %1, %2
  je %3
%endmacro


; ```
; if_equal_jmp al, 32, .endword ; space
; ```
;
%macro if_equal_call 3
  cmp %1, %2
  jne %%3_not_equal
  call %3
%%3_not_equal:
  nop
%endmacro
