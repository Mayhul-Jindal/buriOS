@echo off
cd "C:\Users\mayhul_jindal\OneDrive\coding\OS_DEV"
start nasm -f bin "16bit-bootloader.asm" -o "16bit-bootloader.bin"
cd "C:\Users\mayhul_jindal\OneDrive\coding\OS_DEV"
start qemu-system-x86_64 -drive format=raw,file=16bit-bootloader.bin
pause