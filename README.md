---

# setup

---

Theory
------

When the computer boots, the BIOS doesn't know how to load the OS, so it
delegates that task to the boot sector. Thus, the boot sector must be
placed in a known, standard location. That location is the first sector
of the disk (cylinder 0, head 0, sector 0) and it takes 512 bytes.

To make sure that the "disk is bootable", the BIOS checks that bytes
511 and 512 of the alleged boot sector are bytes `0xAA55`.

This is the simplest boot sector ever:

```
e9 fd ff 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 29 more lines with sixteen zero-bytes each ]
00 00 00 00 00 00 00 00 00 00 00 00 00 00 55 aa
```

It is basically all zeros, ending with the 16-bit value
`0xAA55` (beware of endianness, x86 is little-endian). 
The first three bytes perform an infinite jump

Simplest boot sector ever
-------------------------

You can either write the above 512 bytes
with a binary editor, or just write a very
simple assembler code:

```nasm
; Infinite loop (e9 fd ff)
loop:
    jmp loop 

; Fill with 510 zeros minus the size of the previous code
times 510-($-$$) db 0
; Magic number
dw 0xaa55 
; db - Define byte size variable
; dw - Define word size(2 bytes) variable
; dd - Define double word size(4 bytes) variable
```
- More about `($-$$)`
  
![](.\OS_Resources/Screenshot%202022-02-23%20231055.jpg)


To compile:
`nasm -f bin boot_sect_simple.asm -o boot_sect_simple.bin`

> Will assemble boot_secot.asm into a raw binary file boot_sector.bin.

> You need to understand how these things work. An assembler in itself doesn’t produce executable code - it produces the input to a linker which links your code to a library of called routines (or else multiple libraries of standard and specialised routines) and then you might be able to interactively run the program.

To run:
`qemu-system-x86_64 boot_sect_simple.bin`

> QEMU is a generic and open source machine emulator and virtualizer. When used as a machine emulator, QEMU can run OSes and programs made for one machine (e.g. an ARM board) on a different machine (e.g. your own PC). 

You will see a window open which says "Booting from Hard Disk...". That means setup is correct.

---