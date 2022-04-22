# Setup


1. Download [NASM](https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/win64/) which is an assembler for assembly file.

2. Download [QEMU](https://qemu.weilnetz.de/w64/2021/) for windows(32bit or 64bit)

3. Add to path both of them in order to run them from your command prompt globally, otherwise you have to specify there .exe eveytime to run a command.

4. Now basically use vscode

# Theory For Boot Sector


When the computer boots, the BIOS doesn't know how to load the OS, so it
delegates that task to the boot sector. 

Thus, the boot sector must be placed in a known, standard location. 
That location is the first sector of the disk (cylinder 0, head 0, sector 0) and it takes 512 bytes.

The BIOS checks that bytes 511 and 512 of the alleged boot sector are bytes `0xAA55`. 

If this is found to be true, then the BIOS will 'try' booting the system. Notice the emphasis on the word try because it is possible that the other bytes of the boot sector are corrupted, resulting in improper or no booting.

If in case it's not found (it garbled or 0x0000), we'll get an error message from the BIOS that a bootable disk (where a bootable disk is one which has the magic number `0xAA55` as the last 2 bytes of the first sector, irrespective of it containing uncorrupted boot information) was not found or the system will try to boot the next disk if in case more than one disk is installed in the machine.

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

# Simplest boot sector ever


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
`nasm -f bin boot_sector.asm -o boot_sector.bin`

> Will assemble boot_secot.asm into a raw binary file boot_sector.bin.

> You need to understand how these things work. An assembler in itself doesn’t produce executable code - it produces the input to a linker which links your code to a library of called routines (or else multiple libraries of standard and specialised routines) and then you might be able to interactively run the program.

To run:
`qemu-system-x86_64 boot_sector.bin`

> QEMU is a generic and open source machine emulator and virtualizer. When used as a machine emulator, QEMU can run OSes and programs made for one machine (e.g. an ARM board) on a different machine (e.g. your own PC). 

You will see a window open which says "Booting from Hard Disk...". That means setup is correct.

---

# Basic Stuff


1. Write each character of the "Hello", word into the register `al` (lower part of `ax`), the bytes `0x0e` into `ah` (an Interept service routines which indicates tele-type mode) and raise interrupt `0x10` which causes screen-related ISR to invoke.
   
> We will set tty mode only once, though in the real world we cannot be sure that the contents of ah are constant. Some other process may run on the CPU while we are sleeping, not clean up properly and leave garbage data on ah.

2. Learn about memory referncing and offsets

We can access `check_1` or `check_2` in many different ways:

- `mov al, check_1`
- `mov al, [check_1]`
- `mov al, check_1 + 0x7C00`
- `mov al, 2d + 0x7C00`, where `2d` is the actual position of the 'X' byte in the binary
- Now, since offsetting `0x7c00` everywhere is very inconvenient, assemblers let
us define a "global offset" for every memory location, with the `org` command:

```nasm
[org 0x7c00]
```
3. Learned about looping,function and conditional statements.
```nasm
mov bx, data_to_print
call print ; This essentialy behaves like jmp but additionally,
           ; before junping it pushes the return value into the stack.

print:
    mov ah, 0x0e
    pusha
printFunction:
    mov al,[bx]
    cmp al,0 ; Conditions in assembly
    je return
    int 0x10
    inc bx
    jmp printFunction
return:
    popa
    ret ; This pops the the return address of the stack and jmps to it

data_to_print:
    db "hello world",0
```
4. Learned how to take inputs by interept `0x16`
   
```nasm
buffer:
	times 10 db 0
	mov bx, buffer

characters: 
	cmp bx, 10
	je end
	mov ah, 0
	int 0x16
	mov ah, 0x0e
	mov [bx], al
	int 0x10
	inc bx
	jmp characters

end:
	jmp $

times 510-($-$$) db 0
db 0x55, 0xaa
```
> This can handle only 10 keyboard inputs.

You can examine the binary data with `xxd file.bin` which gives us a hex dump.

# Stack and Segmentation


- Can be used to retrieve a value later simple by just pushing a register value.
  
```nasm
mov bp, 0x8000 ; Set the base of the stack a little above where the BIOS loads, base pointer
mov sp,bp ; stack pointer
mov ah, 0x0e

push 'A'

mov al, 'B'
int 0x10

pop bx ; Storing the push value
mov al, bl
int 0x10
```
This will print `BA`.

- You can `push` and `pop` only 16bit registers
  ![](img/Screenshot%202022-03-04%20142058.jpg)
  
- Segments are used in case where you want more storage space for your work. You can have segments for data(`ds`), code(`cs`), stack(`ss`). Absolute memory in a segment comes out to be `16*ds + offset`

> Instead of this `[org 0x7c00]` origin memory, we can offset the memory like 

```nasm
mov ds, 0x7c0

; Which computes to 16*[0x7c0] + offset = [0x7c00] + offset
```

# Reading from Disk
