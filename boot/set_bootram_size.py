#!/bin/env python3
try:
    from pwnlib.elf import ELF
except ImportError:
    print("set_bootram_size: the pwntools library is required.")
    exit(1)

import subprocess
import sys

if len(sys.argv) < 2:
    print("set_bootram_size: path to the boot image required.")
    exit(1)

elf_file = ELF(sys.argv[1])
address = elf_file.symbols["BOOTRAM_SECTOR_NUMBER"]

binary_size = int(subprocess.run(["size", sys.argv[1]], check=True, capture_output=True).stdout.splitlines()[1].split()[0])
sector_number = binary_size // 512

print(f"set_bootram_size: changing value at {hex(address)} to {sector_number}.")

elf_file.write(address, sector_number.to_bytes(2, "little"))
elf_file.save()
