; vim: :set ft=nasm:

[BITS 16]

; Switch to protected mode
switch_to_pm:
        ; switch off all interrupts
        cli

        ; load our global descriptor table
        lgdt [gdt_descriptor]

        ; to make  the  switch  to  protected  mode , we set the  first  bit
        ; of cr0 , a control  register
        mov eax, cr0
        or eax , 0x1
        mov cr0 , eax

        ; make a far jump (i.e, to a new segment) to our 32-bit code
        ; This forces the CPU to flush its cache of pre-fetched and
        ; real-mode decoded instructions, which can cause problems
        jmp CODE_SEG:init_pm

[bits  32]

init_pm:
        ; old segments are meaningless in PM, so we point our segment
        ; registers to the data selector we defined in our GDT
        mov ax, DATA_SEG
        mov ds, ax
        mov ss, ax
        mov es, ax
        mov fs, ax
        mov gs, ax

        ; update stack position to be at the top of the free space
        mov ebp, 0x90000
        mov esp, ebp

        ; call some well-known label
        call BEGIN_PM
