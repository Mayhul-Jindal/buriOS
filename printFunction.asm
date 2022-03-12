print:
    mov ah, 0x0e
    pusha
printFunction:
    mov al,[bx]
    cmp al,0
    je return
    int 0x10
    inc bx
    jmp printFunction
return:
    popa
    ret
