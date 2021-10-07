#![no_std]
#![no_main]
#![feature(asm)]
#![feature(panic_info_message)]
#![feature(alloc_error_handler)]

use core::alloc::Layout;
use core::panic::PanicInfo;
use buddy_system_allocator::LockedHeap;

#[allow(improper_ctypes)]
extern "C" {
    static bootram_heap_start: ();
    static bootram_heap_end: ();
}
extern crate alloc;

mod bios_services;

#[global_allocator]
static HEAP_ALLOCATOR: LockedHeap<32> = LockedHeap::empty();

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

#[alloc_error_handler]
fn alloc_error_handler(_: Layout) -> ! {
    panic!("Error allocating memory")
}

fn init_allocator() {
    unsafe {
        let start = core::ptr::addr_of!(bootram_heap_start);
        let end = core::ptr::addr_of!(bootram_heap_end);

        HEAP_ALLOCATOR.lock().init(start as usize, end as usize - start as usize)
    }
}

#[no_mangle]
pub extern "C" fn bootram_entry() -> ! {
    bios_services::print_string(b"Executing bootram...\n\r");
    init_allocator();

    let mut xs = alloc::vec::Vec::new();

    xs.push(42);
    if xs.pop() != Some(42) {
        panic!("Some went wrong")
    } else {
        bios_services::print_string(b"Heap is working!\n\r")
    }

    panic!("No boot sequence is defined yet");
}
