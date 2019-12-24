; vim: :set ft=nasm:

[bits 32]

; ensure the linker resolves the address of main()
[extern main]

; ensure we jump straight to the kernel's main
call main
jmp $
