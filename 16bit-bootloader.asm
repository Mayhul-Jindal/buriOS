[org 0x7c00]

mov bp, 0x8000 ; Set the base of the stack a little above where the BIOS loads, base pointer
mov sp,bp ; stack pointer
mov ah, 0x0e

push 'A'

mov al, 'B'
int 0x10

pop bx ; Storing the push value
mov al, bl
int 0x10

xor ax, ax ; Fastest way to zero a register
mov ds, ax ; The segment registers stores the starting addresses of a segment.
           ; To get the exact location of data or instruction within a segment,
           ; an offset value (or displacement) is required. To reference any memory location in a segment,
           ; the processor combines the segment address in the segment register with the offset value of the location.

mov bx, text
call print

mov bx, buriInputBuffer
call input

mov bx, normalInputBuffer
call normalInput

mov bx, normalInputBuffer
call print

jmp $ ;Here, the loader is incomplete, so it's outputting a message and then looping.
      ;The "loop" instruction [hopefully] would be replaced by real code [to be added]. 

%include "printFunction.asm"
%include "inputFunction.asm"
%include "normalInputFunction.asm"
text:
    db "Welcome to buriOS ",0

buriInputBuffer:
    db "buri",0

normalInputBuffer times 100 db 0 ; Enter buffer accoring to  your input

; padding and magic number
times 510-($-$$) db 0
dw 0xaa55
