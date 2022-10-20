## Simple boot loader

Write '+' in UART and stop.

### Info

Find UART memory address in boot log

```
ttyS.0: ttyS0 at MMIO 0xf0800000 (irq = 31) is a ttyS
```

Get load and start adderess when kernel start booting

```
## Booting kernel from Legacy Image at a1000000 ...
   Image Name:   Linux-3.0.8+
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    3286996 Bytes = 3.1 MiB
   Load Address: a0008000
   Entry Point:  a0008000

```

Get size of system kernel partition from boot log

```
[    0.899861] Creating 7 MTD partitions on "spi_flash":
[    0.905472] 0x000000000000-0x000000040000 : "bld"
[    0.912715] 0x000000040000-0x000000050000 : "env"
[    0.918503] 0x000000050000-0x000000060000 : "enc"
[    0.924265] 0x000000060000-0x000000070000 : "usr"
[    0.930050] 0x000000070000-0x0000003f0000 : "sys"
[    0.935953] 0x0000003f0000-0x000000ef0000 : "app"
[    0.941867] 0x000000ef0000-0x000001000000 : "cfg"
```

```
[    0.930050] 0x000000070000-0x0000003f0000 : "sys"
```


UART address - 0xf0800000

Load address - 0xa0008000

Start address - 0xa1000000

Size of system kernel partition - 0x0000003f0000-0x000000070000=0x380000

### Build

Change in Makefile addr to load address (0xa0008000) and uart to UART address (0xf0800000) then build.

```
make clean uboot mkimage
# or with docker
make dbuild build
```

Result in file test.uimg

### Upload loader (test.uimg) via tftp

```
mw.b 0xa1000000 ff 0x380000
tftpboot 0xa1000000 10.80.1.190:test.uimg
```

### Or upload loader (test.uimg) via uart

```
loady
```

Get upload dest address from output `Ready for binary (ymodem) download to 0xA0FFFED8 at 115200 bps...`, in my case is 0xA0FFFED8 

```
mw.b 0xa1000000 ff 0x380000
cp 0xA0FFFED8 0xa1000000 0x70
```

### Run

```
bootm 0xa1000000
```

### Example

```
hisilicon # loady
## Ready for binary (ymodem) download to 0x80008000 at 115200 bps...
C
*** file: test.uimg
$ sz -vv test.uimg
Sending: test.uimg
Bytes Sent:    128   BPS:16                              
Sending: 
Ymodem sectors/kbytes sent:   0/ 0k
Transfer complete

*** exit status: 0 ***
xyzModem - CRC mode, 3(SOH)/0(STX)/0(CAN) packets, 4 retries
## Total Size      = 0x00000070 = 112 Bytes
hisilicon # mw.b 0x82000000 ff 0x300000
hisilicon # cp 0x80008000 0x82000000 0x00000070
hisilicon # bootm 0x82000000
## Booting kernel from Legacy Image at 82000000 ...
   Image Name:   Test loader
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    48 Bytes = 48 Bytes
   Load Address: 80008000
   Entry Point:  80008000
   Loading Kernel Image ... OK
OK

Starting kernel ...

+
```

### Links

https://balau82.wordpress.com/2010/03/10/u-boot-for-arm-on-qemu/

