
# MULTIBOOT HEADER
/* Declare our constants for a multiboot header */
.set ALIGN,  1<<0

.set MEMINFO,  1<<1 /*Retrieved mem map info from our bootloader*/

.set FLAGS, ALIGN | MEMINFO

.set MLB, 0x1BADB002 /*This is the value that GRUB or any other multiboot loader will look for to find our header */

.set CHECKSUM, -(MLB + FLAGS) /* Addition to check if we are in multi boot phase -> same as if CHECKSUM + MLB + FLAGAS == 0: header is real, header is not real */

/*Starting off from ALIGN and MEMINFO, these are 2 bitwise operators that allow for multiple bool flags to be encoded into a
single integer value. We can then use this encoded value to make sure that things are stored in memory in values of 4096.
In 86x a page is defined as 4KB or 4096 bytes. If a value is a multiple of 4096, we can call that page alligned. 
*/

.section .multiboot /* Partitions the following data into a section called multiboot */

.align 16 

.long MLB /*These .long writes a 4 byte file into our output*/

.long FLAGS

.long CHECKSUM

/*MLB + FLAGS + CHECKSUM -> make up the core of the multiboot header. So we are essentially creating an object called multiboot which must of 
16 byte aligned (multiple of 16) and writes 3 32-bit numbers MLB, FLAGS and CHECKSUM which GRUB will scan for*/
/*GRUB only scans the first 8 KiB (8192 bytes) of a file*/

.section .bss

.align 16

stack_bottom:

    .skip 16384 #16 KiB

stack_top:

/*Since our multiboot standard does not intialize an SP (stack pointer), we must initialize it manually*/
/* Our stack pointer:
    - Downward initialized
    - Size of 16384 bytes
    - 16 bytes alignment
    - Stack is in its own section, it is marked as NOBITS (zero-initialized memory)
*/
# NOTE: all stacks on x86 are downwards initialized and must be aligned on 16 bytes

.section .text

.global _start

.type _start, @function

/* Our linker script specifies _start as the entry point to our kernal. Our bootloader will go to this posistion once our kernal has been loaded.
This function has return as the bootloader will be gone. */

/* Our bootloader will loads us into a 32-bit protected mode. This means that paging, interupts are disabled. */
/*NOTE: Paging is the method in which modern operating systems manage memory. Memory is split into a pre-defined size blocks
        Interuptsw*/
_start:

    mov %stack_top, %esp

    call kernal_main

    cli
1:  hlt
    jmp 1b

.size _start, . - _start