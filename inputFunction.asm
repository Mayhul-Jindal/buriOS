input:
    mov ah, 0
    int 0x16
    mov ah, 0x0e
    mov al, [bx]
    int 0x10
    cmp al,'i'
    je end
    inc bx
    jmp input

end:
    ret