include commons/commons.mk

.PHONY: run
run: build
	@echo "$(STYLE_BOLD)- Running image..$(STYLE_RESET)"
	$(EMULATOR) target/boot.bin

.PHONY: run-debug
run-debug: build
	@echo "$(STYLE_BOLD)- Running image in debug mode..$(STYLE_RESET)"
	@echo " Use ‘make start-gdb‘ to start debugging."
	$(EMULATOR) -s -S target/boot.bin

.PHONY: start-gdb
start-gdb:
	gdb -ex "target remote localhost:1234" -ex "symbol-file boot.elf" -ex "br *0x7c00"

.PHONY: build
build:
	@mkdir -pv target
	@$(MAKE) -C boot build
	@echo "$(STYLE_BOLD)[!] Build successful$(STYLE_RESET)"

.PHONY: clean
clean:
	@echo "$(STYLE_BOLD)- Cleaning..$(STYLE_RESET)"
	rm -rfv $(TARGET_DIR)/*.o

.PHONY: clean-all
clean-all: clean
	rm -rfv $(CARGO_PATH) boot/Cargo.lock

.PHONY: print-versions
print-versions:
	@$(ASM) -v
	@cargo -V
	@rustc -V
	@$(AR) -V | head -n 1
	@$(LD) -v
	@$(OBJCOPY) -V | head -n 1