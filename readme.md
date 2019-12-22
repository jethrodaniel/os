# os

What is a bootloader?

When your computer boots up, it starts the BIOS (Basic Input/Output System),
which:

- performs hardware tests (memory checks)
- enables changing various settings
- prints logo, diagnostic, etc
- attempts to load an operating system from any bootable media

When trying to load an OS, the BIOS reads the first 512 bytes from the boot
devices and checks if the last two of these 512 bytes contain 0x55AA. If so,
the BIOS moves the 512 bytes to the memory address 0x7c00 and treats whatever
was at the beginning of the 512 bytes as code, i.e, the bootloader.
