ENTRY(bootloader_entry)

MEMORY {
    bootloader (RX)  : ORIGIN = 0x7c00,  LENGTH = 512
    bootram (WX)     : ORIGIN = 0x7e00,  LENGTH = 3608576
    bootram_heap (X) : ORIGIN = 0x76000, LENGTH = 40960
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
        *bootram.a:*;
    } > bootram
    bootram_heap : {
        bootram_heap_start = ORIGIN(bootram_heap);
        bootram_heap_end = LENGTH(bootram_heap);
    } > bootram_heap
}