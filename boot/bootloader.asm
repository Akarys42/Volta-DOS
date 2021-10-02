extern bootram_data, bootram_entry, BOOTRAM_SECTOR_NUMBER
global bootloader_entry

bits 16
section .text

bootloader_entry:
  mov ax, 0
  mov ds, ax ; Zero out ds

  cld ; Clear direction flag
  mov sp, 0x7c00 ; Initialize stack

  ; Load bootram
  mov si, message_loading_bootram
  call print_str
  call load_bootram
  mov si, message_loaded_bootram
  call print_str

  jmp bootram_entry

; Stop the cpu
stop:
  mov si, message_halting
  call print_str
  cli 
  hlt


; Print null terminated string starting at [si]
print_str: 
  lodsb
  cmp al, 0
  jne .body
  ret
.body:
  call print_char
  jmp print_str


; Print character in the al register 
print_char:
  mov ah, 0x0e ; teletype mode
  int 0x10
  ret


; Load the bootram in bootram_data
load_bootram:
  clc
  mov si, LBA_ADDRESS_PACKET
  mov ah, 0x42 ; Extended Read Sectors From Drive
  int 13h
  jc .error
  ret
.error:
  mov al, "R"
  call print_char
  mov si, message_error
  call print_str
  jmp stop


section .data

; LBA packet used to read the bootram
align 4
LBA_ADDRESS_PACKET:
  db 0x10         ; Packet size
  db 0            ; Unused
BOOTRAM_SECTOR_NUMBER:
  dw 0            ; Number of sectors to read
  dw bootram_data ; Destination buffer
  dw 0            ; Memory page
  dd 1            ; Lower LBA address
  dd 0            ; Higher LBA address


message_loading_bootram db "Loading bootram...", 0xA, 0xD, 0
message_loaded_bootram db "Bootram loaded", 0xA, 0xD, 0
message_error db " - Error", 0xA, 0xD, 0
message_halting db "CPU halted", 0
