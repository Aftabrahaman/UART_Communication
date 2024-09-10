# UART_Communication
Universal Asynchronous Receiver Transmitter (UART) is a hardware communication protocol that allows two devices to exchange serial data.


How it works
UART uses two wires to transmit and receive data in both directions. It converts parallel data from a computer into a serial bit stream for transmission, and vice versa. 
 
Transmission modes
UART can operate in simplex, half-duplex, or full-duplex modes. In simplex mode, data is only sent in one direction, while in half-duplex mode, only one side can transmit at a time. In full-duplex mode, both sides can transmit simultaneously. 
 
Error checking
UART uses a parity bit to check for errors in data transmission. The receiver checks for an even number of 1's in the data, including the parity bit. If more than one bit is corrupted, the error-checking mechanism fails. 
 
Uses
UART is commonly used in embedded systems, microcontrollers, and computers to communicate between devices. It's also used as the back-end for consoles through USB-to-UART convertors
