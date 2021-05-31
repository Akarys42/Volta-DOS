ENTRY(bootloader_entry)

MEMORY {
    bootloader (RX) : ORIGIN = 0x7c00, LENGTH = 0x200
    bootram (WX)    : ORIGIN = 0x7e00, LENGTH = 0xF8200
}

SECTIONS {
    bootloader : {
        *bootloader.o(.text)
        *bootloader.o(.data)
        . = 0x1fe;
        SHORT(0xaa55)
    } > bootloader
    bootram : {
        bootram_data = .;
        *bootram.a(.text)
        *bootram.a(.data)
        *bootram.a(.bss)
    } > bootram
}