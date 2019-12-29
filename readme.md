# os

a 32-bit x86 operating system, for education's sake

### prereqs

```
sudo apt-get install build-essential qemu make nasm gcc curl texinfo
```

### install

```
git clone https://github.com/jethrodaniel/os
cd os
make cross-compiler # oh lawd he compiling (one-time)
make
```

that'll setup a cross-compiler (and gdb) for i386 (gcc, binutils, etc) - this takes a **while**

### license

MIT.

### references

- https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf
- https://github.com/cfenollosa/os-tutorial
- https://pdos.csail.mit.edu/6.828/2011/schedule.html
- https://wiki.osdev.org/Bare_Bones
- https://www.nayuki.io/page/a-fundamental-introduction-to-x86-assembly-programming
- https://50linesofco.de/post/2018-02-28-writing-an-x86-hello-world-bootloader-with-assembly
- http://joebergeron.io/posts/post_two.html
- https://geosn0w.github.io/An-Introduction-To-Intel-x86-Assembly/
- http://flint.cs.yale.edu/cs421/papers/x86-asm/asm.html
- https://eli.thegreenplace.net/2011/09/06/stack-frame-layout-on-x86-64
- https://eli.thegreenplace.net/2011/02/04/where-the-top-of-the-stack-is-on-x86/

thanks y'all (especially those top 4).
