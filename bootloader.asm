bits 16
org 0x7c00

mov ax, 0
mov ds, ax ; Zero out ds

; Load bootram
mov si, message_loading_bootram
call print_str
call load_bootram
mov si, message_loaded_bootram
call print_str
mov si, test_message
call print_str

; Stop the cpu
mov si, message_halting
call print_str
cli 
hlt


; LBA packet used to read the bootram
LBA_ADDRESS_PACKET:
  db 0x10         ; Packet size
  db 0            ; Unused
  dw 1            ; Number of sectors to read
  dw bootram_data ; Destination buffer
  dw 0            ; Memory page
  dd 1            ; Lower LBA address
  dd 0            ; Higher LBA address


; Print null terminated string starting at [si]
print_str: 
  lodsb
  cmp al, 0
  jne .body
  ret
.body:
  call print_char
  jmp print_str


; Print character into the al register 
print_char:
  mov ah, 0x0e ; teletype mode
  int 0x10
  ret


; Load the bootram in bootram_data
load_bootram:
  mov si, LBA_ADDRESS_PACKET
  mov ah, 0x42 ; Extended Read Sectors From Drive
  int 13h
  jc .error
  ret
.error:
  mov al, "R"
  call print_char
  mov si, message_error
  ret


message_loading_bootram db "Loading bootram...", 0xA, 0xD, 0
message_loaded_bootram db "Bootram loaded", 0xA, 0xD, 0
message_error db " - Error", 0xA, 0xD, 0
message_halting db "Halt!", 0

times 510 - ($ - $$) db 0 ; Fill the rest of sector with 0
dw 0xaa55                 ; Boot magic number

; This section will be filled by the load_bootram routine from disk
; do NOT try to use it before it is loaded
bootram_data:
  test_message db "Test message", 0xA, 0xD, 0