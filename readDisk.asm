load_disk:
    push dx 
    mov ah, 0x02; BIOS read sector function
    mov al, dh; Read n sectors(value of n stored in dh) from the start point
    mov ch, 0x00; Select cylinder 0
    mov dh, 0x00; Select the track on the 1st side of the floppy-disk/ Select head 0
    mov cl, 0x02; Start reading from the 2nd sector
    
    int 0x13; BIOS interupt to actually read the disk

    ; The carry flag(CF) is a special flag register, which basically
    ; stores a value that will tell us if there is any issue or not
    jc disk_error_1

    pop dx
    cmp dh, al
    jne disk_error_2
    ; jmp disk_success
    ret

disk_error_1:
    mov bx, disk_error_message_1
    call print
    jmp $

disk_error_2:
    mov bx, disk_error_message_2
    call print
    jmp $

disk_error_message_1: db "Disk read error",0
disk_error_message_2: db "doosri wali error ayi hain ab",0


