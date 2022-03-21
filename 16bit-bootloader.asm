[org 0x7c00]

mov [BOOT_DRIVE], dl; BIOS stores our boot_drive in dl register
; -----Stack implementation-----

mov bp, 0x8000 ; Set the base of the stack a little above where the BIOS loads, base pointer
mov sp,bp ; stack pointer
mov ah, 0x0e

push 'A'

mov al, 'B'
int 0x10

pop bx ; Storing the push value
mov al, bl
int 0x10

; Here we are specifying the address in the format
; [es:bx], where we would like the  BIOS to read its sector
mov bx, 0x0000
mov es, bx
mov bx, 0x9000

mov dh, 5
mov dl, [BOOT_DRIVE]
call load_disk

mov dx, [0x9000] ;Printing first word from the first loaded sector 
call print

mov dx, [0x9000 + 512] ;Printing first word from the second loaded sector
call print 

; -----Till here-----

xor ax, ax ; Fastest way to zero a register
mov ds, ax ; The segment registers stores the starting addresses of a segment.
           ; To get the exact location of data or instruction within a segment,
           ; an offset value (or displacement) is required. To reference any memory location in a segment,
           ; the processor combines the segment address in the segment register with the offset value of the location.

mov bx, text
call print

mov bx, buriInputBuffer ; Buri wali  cheez
call input

mov bx, normalInputBuffer ; Takes input
call normalInput

mov bx, normalInputBuffer ; Prints the input value
call print

jmp $ ;Here, the loader is incomplete, so it's outputting a message and then looping.
      ;The "loop" instruction [hopefully] would be replaced by real code [to be added]. 

%include "printFunction.asm"
%include "inputFunction.asm"
%include "normalInputFunction.asm"
%include "readDisk.asm"

text:
    db "Welcome to buriOS ",0

buriInputBuffer:
    db "buri",0

normalInputBuffer times 100 db 0 ; Enter buffer accoring to  your input

BOOT_DRIVE:
    db 0

; padding and magic number
times 510-($-$$) db 0
dw 0xaa55

; As BIOS will only read fisrt sector which is 512 bytes, we will add
; some additional sectors to prove that we are reading from disk.
times 256 dw 0xdada
times 256 dw 0xface