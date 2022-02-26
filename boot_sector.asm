[org 0x7c00] ; Explicitly telling where to expect the code to load in the memory,
             ; this saves us from the hassle of label--memory offset
; -------------------------Printing stuff on console-------------------------------
mov ah, 0x0e

mov al, 'B'
int 0x10
mov al, 0x55
int 0x10
mov al, 82
int 0x10
mov al, 0b01001001
int 0x10
mov al, [check_1] ; We used square brackets to store the content of an address
int 0x10
mov al, [check_2]
int 0x10
mov al, ' '
int 0x10
mov bx, string ; pointer to string

printString:
    mov al,[bx]
    cmp al,0
    je init
    int 0x10
    inc bx
    jmp printString

init:
    mov al, ' '
    int 0x10
    mov al, 64

printAlpha:
    inc al
    cmp al, 'Z' + 1
    je printInput
    int 0x10
    jmp printAlpha

check_1: ; These are labels, ig these are memory address 
    db 0x4F
check_2:
    db 0x53
string: ; Pointer to the first character of the string
    db "Alphabets",0 ; every string ends with null byte

; -------------------------Input from keyboard-------------------------------

tryburi:
    db "buri",0
    mov bx, tryburi

printInput:
    mov ah, 0
    int 0x16
    mov ah, 0x0e
    mov al, [bx]
    int 0x10
    cmp al,'i'
    je end
    inc bx
    jmp printInput
; --------------------------------------------------------
end:
    jmp $ ; Infinite loop (e9 fd ff)

times 510-($-$$) db 0 ; Fill with zeros till 510th byte minus the bytes occupied by the previous code

dw 0xaa55 ; Magic number
; db - Define byte size variable
; dw - Define word size(2 bytes) variable
; dd - Define double word size(4 bytes) variable