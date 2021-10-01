include ../commons/commons.mk

.PHONY: build
build: $(TARGET_DIR)/boot.bin
	@echo "$(STYLE_BOLD)[!] Boot build successful$(STYLE_RESET)"

$(TARGET_DIR)/boot.bin: $(TARGET_DIR)/bootloader.o $(TARGET_DIR)/bootram.o boot.ld
	@echo "$(STYLE_BOLD)- Assembling boot image..$(STYLE_RESET)"

	$(eval bootloader_size := $(shell size $(TARGET_DIR)/bootloader.o | tail -1 | cut -f 4))
	@echo "$(STYLE_BOLD)=> Bootloader is using $(bootloader_size) bytes out of 512\
	 ($(shell awk 'BEGIN{printf("%.2f",$(bootloader_size)/512*100)}')%).$(STYLE_RESET)"

	@if [ $(bootloader_size) -gt 512 ]; then echo "error: bootloader too large" && exit 1; fi

	$(LD) -T boot.ld -m elf_i386 --gc-sections -o $(TARGET_DIR)/boot.elf $(TARGET_DIR)/bootloader.o $(TARGET_DIR)/bootram.a
	$(OBJCOPY) -S -O binary $(TARGET_DIR)/boot.elf $(TARGET_DIR)/boot.bin
	@echo "$(STYLE_BOLD)=> Boot image is $$(stat --printf="%s" $(TARGET_DIR)/boot.bin) bytes long.$(STYLE_RESET)"

$(TARGET_DIR)/bootloader.o: bootloader.asm
	@echo "$(STYLE_BOLD)- Assembling bootloader..$(STYLE_RESET)"
	$(ASM) -g -F dwarf -f elf32 -o $(TARGET_DIR)/bootloader.o bootloader.asm

$(TARGET_DIR)/bootram.o: bootram/*.rs
	@echo "$(STYLE_BOLD)- Compiling bootram..$(STYLE_RESET)"
	$(RUST) $(RUST_FLAGS) --release -- -C panic=abort --emit=obj
	@rm -f $(TARGET_DIR)/bootram.a && mv -v $(CARGO_TARGET_DIR)/$(RUST_TARGET)/release/libbootram.a $(TARGET_DIR)/bootram.a
	@rm -f *.o
