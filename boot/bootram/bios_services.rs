pub fn print_char(character: u8) {
    unsafe {
        asm!(
            "
            mov ah, 0x0e
            int 0x10
            ", in("al") character, lateout("ah") _
        )
    }
}

pub fn print_string(string: &[u8]) {
    for character in string {
        print_char(*character)
    }
}

pub fn print_number(mut num: u32) {
    loop {
        print_char((num % 10 + 0x30) as u8);
        num = num / 10;

        if num == 0 {
            break
        }
    }
}