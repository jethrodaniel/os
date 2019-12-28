## boot

The code here is loaded from BIOS, and loads the kernel.

### x86

general purpose registers

```
63            32 31           16 15    8 7      0
+---------------+-------------------------------+
|      r        |      e       |  ah   |  al    |
|               |              |  bh   |  bl    |
|               |              |  ch   |  cl    |
|               |              |  dh   |  dl    |
|               |              |  --- bp -----  |
|               |              |      si        |
|               |              |      di        |
|               |              |      sp        |
+---------------+-------------------------------+

 64-bit | 32-bit | 16-bit
------- +------- + -------
  rax   |  eax   |   ax
  rbx   |  ebx   |   bx
  rcx   |  ecx   |   cx
  rdx   |  edx   |   dx
  rbp   |  ebp   |
  rsi   |  esi   |
  rdi   |  edi   |
  rsp   |  esp   |
  r8
  r9
  r10
  r11
  r12
  r13
  r14
  r15
```

#### stack

bp - base address (i.e. bottom) of the stack
sp - top of the stack

the stack grows _downward_ from bp (so sp gets decremented).

#### physical memory layout

todo: 64 bit


```
+--------------------+ <- 0xffffffff (4gb)
| 32-bit             |
| mem-mapped devices |
|                    |
+--------------------+
|                    |
| extended memory    |
|                    |
+--------------------+ <- 0x100000 (1mb)
| BIOS               | <- 0xc0000 (256 kb)
| video memory       | <- 0xa0000 (128 kb)
| extended BIOS data | <- 0xa0000 (639 kb)
| free               | <- 0x9fc00 (638 kb)
| loaded boot sector | <- 0x7e00 (512 bytes)
| low memory         | <- 0x7c00 (bootloader execution start)
| BIOS data area     | <- 0x0500 (256 bytes)
|  IVT               | <- 0x0400 (interrupt vector table, 1kb)
+--------------------+ <- 0x0000
```

## sequence

- pc powers on, which kicks off the BIOS (in 16-bit real mode)
- BIOS makes sure memory and disks are good, etc
- BIOS proceeds to find a bootable device to boot

Devices are "bootable" if their 511th and 512th bytes match a magic number.

If so, that first sector (512 bytes) is moved to address `0x7c00`, where it is
executed.

The bootloader is run in 16-bit real mode, a legacy mode with 64KiB of memory,
and no virtual addresses (todo, explain).

That bootloader is responsible for

- todo
- todo
