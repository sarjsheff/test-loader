volatile unsigned int *const UART0DR = (unsigned int *)0xA0008000;//uartaddress

void c_entry()
{
	*UART0DR = '+';
	while (1) {}
}
