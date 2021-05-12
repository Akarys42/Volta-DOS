bits 16
org 0x7c00

mov ax, 0
mov ds, ax ; Zero out ds

mov si, message_loading_bootram
call print_str

; Stop the cpu
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

; Print character into the al register 
print_char:
  mov ah, 0x0e ; teletype mode
  int 0x10
  ret


message_loading_bootram db "Loading bootram", 0xA, 0xD, 0
message_halting db "Halt!", 0

times 510 - ($ - $$) db 0 ; Fill the rest of sector with 0
dw 0xaa55                 ; Boot magic number