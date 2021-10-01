# Common makefile definitions

ASM := nasm
RUST := cargo +nightly rustc
LD := ld
OBJCOPY := objcopy
EMULATOR := qemu-system-i386 -nographic

ROOT_DIR:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))
TARGET_DIR := $(abspath $(ROOT_DIR)../target)
CARGO_TARGET_DIR := $(TARGET_DIR)/cargo

RUST_TARGET := i386-unknown-none-code16
RUST_FLAGS := --target $(realpath ../commons/$(RUST_TARGET).json)\
 --target-dir $(CARGO_TARGET_DIR) -Z build-std=core,alloc

STYLE_BOLD := $(shell tput bold)
STYLE_RESET := $(shell tput sgr0)
