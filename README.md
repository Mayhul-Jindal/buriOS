Setup
-----

1. Download [NASM](https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/win64/) which is an assembler for assembly file.

2. Download [QEMU](https://qemu.weilnetz.de/w64/2021/) for windows(32bit or 64bit)

3. Add to path both of them in order to run them from your command prompt globally, otherwise you have to specify there .exe eveytime to run a command.

4. Now basically use vscode

Theory For Boot Sector
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

![Screenshot 2022-02-23 231055](https://user-images.githubusercontent.com/95216160/155675807-87fa0dcb-6725-4af7-9f37-7b251f1ff12b.jpg)

To compile:
`nasm -f bin boot_sect_simple.asm -o boot_sect_simple.bin`

> Will assemble boot_secot.asm into a raw binary file boot_sector.bin.

> You need to understand how these things work. An assembler in itself doesn’t produce executable code - it produces the input to a linker which links your code to a library of called routines (or else multiple libraries of standard and specialised routines) and then you might be able to interactively run the program.

To run:
`qemu-system-x86_64 boot_sect_simple.bin`

> QEMU is a generic and open source machine emulator and virtualizer. When used as a machine emulator, QEMU can run OSes and programs made for one machine (e.g. an ARM board) on a different machine (e.g. your own PC). 

You will see a window open which says "Booting from Hard Disk...". That means setup is correct.
