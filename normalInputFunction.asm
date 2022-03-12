normalInput:
    ; Keyboard wait
    mov ah, 0
    int 0x16

    ; Check if we pressed the enter key
    ; C equivalent:
    ; if(al == '\n') jmp endInput;
    cmp al, 0x0D
    je endInput

    ; Switch to Tele-print mode and print the char register (prints al which has the char)
    mov ah, 0x0E
    int 0x10

    ; Move the char to the buffer indexed by bx
    ; C equivalent:
    ; buffer[bx] = al; bx++;
    mov [bx], al
    inc bx

    ; Jump back to the keyboard wait
    jmp normalInput

endInput:
    ret
