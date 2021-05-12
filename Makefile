ASM = nasm
ASM_FLAGS = -f bin

EMULATOR = qemu-system-x86_64 -nographic

run: bootloader.bin
	${EMULATOR} bootloader.bin

bootloader.bin: bootloader.asm
	@echo "[] Compiling bootloader.."
	${ASM} ${ASM_FLAGS} bootloader.asm -o bootloader.bin

clean:
	@rm *.bin -v