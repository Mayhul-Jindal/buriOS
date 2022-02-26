@echo off
cd "C:\Users\mayhul_jindal\OneDrive\coding\OS_DEV"
start nasm -f bin boot_sector.asm -o boot_sector.bin
cd "C:\Users\mayhul_jindal\OneDrive\coding\OS_DEV"
start qemu-system-x86_64 -drive format=raw,file=boot_sector.bin
pause