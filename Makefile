ASM := nasm
RUST := cargo +nightly rustc
AR := ar
LD := ld
OBJCOPY := objcopy
EMULATOR := qemu-system-i386 -nographic

RUST_TARGET := x86_real-unknown-none
RUST_FLAGS := --target $(RUST_TARGET).json -Z build-std=core,alloc


.PHONY: run
run: build
	$(EMULATOR) boot.bin

.PHONY: run-debug
run-debug: build
	$(EMULATOR) -s -S boot.bin

.PHONY: start-gdb
start-gdb:
	gdb -ex "target remote localhost:1234" -ex "symbol-file boot.elf" -ex "br *0x7c00"

.PHONY: build
build: boot.bin
	@echo "[!] Build successful"


boot.bin: bootloader.o bootram.o boot.ld
	$(eval bootloader_size := $(shell size bootloader.o | tail -1 | cut -f 4))
	@echo "=> Bootloader is using $(bootloader_size) bytes out of 512\
	 ($(shell awk 'BEGIN{printf("%.2f",$(bootloader_size)/512*100)}')%)."
	@if [ $(bootloader_size) -gt 512 ]; then echo "error: bootloader too large" && exit 1; fi
	$(LD) -T boot.ld -m elf_i386 -o boot.elf bootloader.o bootram.o
	$(OBJCOPY) -S -O binary boot.elf boot.bin
	@echo "=> Boot image is $$(stat --printf="%s" boot.bin) bytes long."

bootloader.o: bootloader.asm
	@echo "- Compiling bootloader.."
	$(ASM) -g -F dwarf -f elf32 bootloader.asm -o bootloader.o

bootram.o: bootram.rs
	$(eval target := target/$(RUST_TARGET)/debug/libbootram.a)
	@echo "- Compiling bootram.."
	$(RUST) $(RUST_FLAGS) -- -C panic=abort --emit=obj
	@$(AR) x $(target) $$(ar t $(target) | grep bootram)
	@mv -v bootram-*.o bootram.o


.PHONY: clean
clean:
	@echo "- Cleaning.."
	rm -rfv *.bin *.o *.elf

.PHONY: clean-all
clean-all:
	make clean
	rm -rfv target/ Cargo.lock

.PHONY: print-versions
print-versions:
	@$(ASM) -v
	@cargo -V
	@rustc -V
	@$(AR) -V | head -n 1
	@$(LD) -v
	@$(OBJCOPY) -V | head -n 1