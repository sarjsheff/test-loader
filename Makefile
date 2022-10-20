arch=arm926ej-s

# hi3518 = 0x80008000 fh81 = 0xA0008000
addr=0x80008000

# 0x101f1000 qemu
# 0x20080000 hi3518
# 0xf0800000 fh81
uart=0x20080000

uboot:
	arm-none-eabi-as -mcpu=$(arch) -g startup.s -o startup.o
	sed 's/0xA0008000/$(uart)/g' test.c > gentest.c
	arm-none-eabi-gcc -c -mcpu=$(arch) -Duartaddress=$(uart) gentest.c -o test.o
	sed 's/0xA0008000/$(addr)/g' test.ld > gentest.ld
	arm-none-eabi-ld -T gentest.ld -Map=test.map test.o startup.o -o test.elf
	arm-none-eabi-objcopy -O binary test.elf test.bin

mkimage:
	mkimage -A arm -C none -n 'Test loader' -O linux -T kernel -d test.bin -a $(addr) -e $(addr) test.uimg

com:
	screen -L picocom -b 115200 /dev/ttyUSB0

dbuild:
	docker build -t sheff/cross .

qemu:
	qemu-system-arm -M versatilepb -m 128M -nographic -kernel test.bin

tftp:
	sudo dnsmasq -kd -p 0 -C /dev/null -u nobody --enable-tftp --tftp-root=$(shell pwd)

build:
	docker run -it --rm -v $(shell pwd):/build -w /build sheff/cross make clean uboot mkimage

clean:
	-rm startup.o test.o test.bin test.elf test.uimg
