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
