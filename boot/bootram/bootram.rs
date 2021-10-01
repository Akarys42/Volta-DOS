#![no_std]
#![no_main]
#![feature(asm)]

use core::panic::PanicInfo;

#[panic_handler]
fn panic_handler(_: &PanicInfo) -> ! {
    unsafe {asm!("
    mov al, 'P'
    mov ah, 0x0e
    int 0x10
    ")};

    loop {}
}

#[no_mangle]
pub extern "C" fn bootram_entry() -> ! {
    unsafe {asm!("
    mov al, 'X'
    mov ah, 0x0e
    int 0x10
    ")};
    panic!();

    loop {}
}
