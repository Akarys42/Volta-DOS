#![no_std]
#![no_main]
#![feature(asm)]
#![feature(panic_info_message)]

use core::panic::PanicInfo;

mod bios_services;

#[panic_handler]
fn panic_handler(panic_info: &PanicInfo) -> ! {
    bios_services::print_string(b"Bootram panicked");

    if let Some(location) = panic_info.location() {
        bios_services::print_string(b" at ");
        bios_services::print_string(location.file().as_bytes());
        bios_services::print_char(b":"[0]);
        bios_services::print_number(location.line());
    }

    if let Some(arguments) = panic_info.message() {
        if let Some(message) = arguments.as_str() {
            bios_services::print_string(b": ");
            bios_services::print_string(message.as_bytes());
        }
    }

    bios_services::print_string(b"\n\rCPU halted");
    loop {}
}

#[no_mangle]
pub extern "C" fn bootram_entry() -> ! {
    bios_services::print_string(b"Executing bootram...\n\r");

    panic!("No boot sequence is defined yet");
}
